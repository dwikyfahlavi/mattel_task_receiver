# Generates launcher-icon sources and the notification icon from the Mattel logo.
#
#   powershell -ExecutionPolicy Bypass -File tool\icons\generate_icon_sources.ps1
#   then:  cd apps\app_watch  && fvm dart run flutter_launcher_icons
#          cd apps\app_mobile && fvm dart run flutter_launcher_icons
#
# Input : design/assets/brands/logo_transparent.svg (wraps a 300x300 PNG).
# Output: design/assets/icons/*.png (inputs for flutter_launcher_icons) and
#         apps/*/android/app/src/main/res/drawable-*/ic_stat_task.png (notification).
# Windows only (System.Drawing). Re-run when the logo changes.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = Resolve-Path "$PSScriptRoot\..\.."
$out = "$root\design\assets\icons"
New-Item -ItemType Directory -Force $out | Out-Null

# ---------------------------------------------------------------- source logo
$svg = [IO.File]::ReadAllText("$root\design\assets\brands\logo_transparent.svg")
$b64 = [regex]::Match($svg, 'data:image/png;base64,([A-Za-z0-9+/=]+)').Groups[1].Value
$raw = [Drawing.Bitmap]::new([IO.MemoryStream]::new([Convert]::FromBase64String($b64)))

function Get-Pixels([Drawing.Bitmap]$bmp) {
  $rect = [Drawing.Rectangle]::new(0, 0, $bmp.Width, $bmp.Height)
  $data = $bmp.LockBits($rect, 'ReadOnly', [Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $bytes = [byte[]]::new($data.Stride * $bmp.Height)
  [Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
  $bmp.UnlockBits($data)
  return ,$bytes   # BGRA, stride = width*4 for 32bpp
}

function New-FromPixels([byte[]]$bytes, [int]$w, [int]$h) {
  $bmp = [Drawing.Bitmap]::new($w, $h, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $data = $bmp.LockBits([Drawing.Rectangle]::new(0, 0, $w, $h), 'WriteOnly', [Drawing.Imaging.PixelFormat]::Format32bppArgb)
  [Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
  $bmp.UnlockBits($data)
  return $bmp
}

# Tight crop to the visible logo (alpha > 8).
$px = Get-Pixels $raw
$w = $raw.Width; $h = $raw.Height
$minX = $w; $minY = $h; $maxX = 0; $maxY = 0
for ($y = 0; $y -lt $h; $y++) { for ($x = 0; $x -lt $w; $x++) {
  if ($px[($y * $w + $x) * 4 + 3] -gt 8) {
    if ($x -lt $minX) { $minX = $x }; if ($x -gt $maxX) { $maxX = $x }
    if ($y -lt $minY) { $minY = $y }; if ($y -gt $maxY) { $maxY = $y }
  } } }
$side = [Math]::Max($maxX - $minX, $maxY - $minY) + 1
$logo = [Drawing.Bitmap]::new($side, $side)
$g = [Drawing.Graphics]::FromImage($logo)
$g.DrawImage($raw, [Drawing.Rectangle]::new(($side - ($maxX - $minX + 1)) / 2, ($side - ($maxY - $minY + 1)) / 2, $maxX - $minX + 1, $maxY - $minY + 1), [Drawing.Rectangle]::new($minX, $minY, $maxX - $minX + 1, $maxY - $minY + 1), 'Pixel')
$g.Dispose()

# Silhouette: red starburst -> opaque white, white letters -> transparent.
# whiteness = how far min(G,B) is from the brand red (G=0x1C) towards white.
$lp = Get-Pixels $logo
$sil = [byte[]]::new($lp.Length)
for ($i = 0; $i -lt $lp.Length; $i += 4) {
  $b = $lp[$i]; $gg = $lp[$i + 1]; $a = $lp[$i + 3]
  $white = ([Math]::Min($b, $gg) - 28) / (255.0 - 28)
  if ($white -lt 0) { $white = 0 } elseif ($white -gt 1) { $white = 1 }
  $sil[$i] = 255; $sil[$i + 1] = 255; $sil[$i + 2] = 255
  $sil[$i + 3] = [byte][Math]::Round($a * (1 - $white))
}
$silhouette = New-FromPixels $sil $logo.Width $logo.Height

# ------------------------------------------------------------------ helpers
function New-Canvas([int]$size) {
  $bmp = [Drawing.Bitmap]::new($size, $size, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $gr = [Drawing.Graphics]::FromImage($bmp)
  $gr.InterpolationMode = 'HighQualityBicubic'
  $gr.SmoothingMode = 'AntiAlias'
  $gr.PixelOffsetMode = 'HighQuality'
  $gr.TextRenderingHint = 'AntiAliasGridFit'
  $gr.Clear([Drawing.Color]::Transparent)
  return @($bmp, $gr)
}

function Draw-Centered($gr, $img, [int]$canvas, [double]$fraction) {
  $s = [int]($canvas * $fraction)
  $o = [int](($canvas - $s) / 2)
  $gr.DrawImage($img, $o, $o, $s, $s)
}

$fonts = [Drawing.Text.PrivateFontCollection]::new()
$fonts.AddFontFile("$root\packages\ui_kit\fonts\Inter-Bold.ttf")
$inter = $fonts.Families[0]

# Flavor badge: dark pill across the lower part of the logo, inside the
# adaptive-icon safe zone (centre 66/108 of the canvas).
function Draw-Badge($gr, [int]$canvas, [string]$label) {
  $bw = [int]($canvas * 0.40); $bh = [int]($canvas * 0.13)
  $x = [int](($canvas - $bw) / 2); $y = [int]($canvas * 0.66)
  $path = [Drawing.Drawing2D.GraphicsPath]::new()
  $r = $bh
  $path.AddArc($x, $y, $r, $bh, 90, 180)
  $path.AddArc($x + $bw - $r, $y, $r, $bh, 270, 180)
  $path.CloseFigure()
  $gr.FillPath([Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 10, 10, 10)), $path)
  $font = [Drawing.Font]::new($inter, [float]($bh * 0.62), [Drawing.FontStyle]::Bold, [Drawing.GraphicsUnit]::Pixel)
  $fmt = [Drawing.StringFormat]::new(); $fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
  $gr.DrawString($label, $font, [Drawing.Brushes]::White, [Drawing.RectangleF]::new($x, $y + $bh * 0.04, $bw, $bh), $fmt)
}

function Save-Icon([string]$name, [double]$fraction, [string]$badge, $img) {
  $c = New-Canvas 1024
  Draw-Centered $c[1] $img 1024 $fraction
  if ($badge) { Draw-Badge $c[1] 1024 $badge }
  $c[1].Dispose()
  $c[0].Save("$out\$name", [Drawing.Imaging.ImageFormat]::Png)
  $c[0].Dispose()
}

# ---------------------------------------------------------- launcher sources
# Adaptive foreground: logo within the safe zone (61% of the 108dp canvas).
# Legacy icon (API 24-25): logo nearly full size on transparent.
foreach ($flavor in @(@('', ''), @('_dev', 'DEV'), @('_staging', 'STG'))) {
  Save-Icon "foreground$($flavor[0]).png" 0.58 $flavor[1] $logo
  Save-Icon "legacy$($flavor[0]).png" 0.92 $flavor[1] $logo
}
Save-Icon 'monochrome.png' 0.58 '' $silhouette

# ------------------------------------------------------- notification icon
# Status-bar icon: 24dp, white on transparent, ~1dp padding.
$densities = @{ 'mdpi' = 24; 'hdpi' = 36; 'xhdpi' = 48; 'xxhdpi' = 72; 'xxxhdpi' = 96 }
foreach ($app in 'app_watch', 'app_mobile') {
  foreach ($d in $densities.Keys) {
    $size = $densities[$d]
    $dir = "$root\apps\$app\android\app\src\main\res\drawable-$d"
    New-Item -ItemType Directory -Force $dir | Out-Null
    $c = New-Canvas $size
    Draw-Centered $c[1] $silhouette $size (22.0 / 24.0)
    $c[1].Dispose()
    $c[0].Save("$dir\ic_stat_task.png", [Drawing.Imaging.ImageFormat]::Png)
    $c[0].Dispose()
  }
}
$c = New-Canvas 96; Draw-Centered $c[1] $silhouette 96 (22.0 / 24.0); $c[1].Dispose()
$c[0].Save("$out\notification.png", [Drawing.Imaging.ImageFormat]::Png); $c[0].Dispose()

# --------------------------------------------------- Android launcher icons
# main/res = prod icon (adaptive + monochrome + legacy). dev/ and staging/
# override only the bitmaps with badged versions (same file names), so the
# adaptive XML and colour are shared.
function Save-Resized([string]$src, [string]$dest, [int]$size) {
  $img = [Drawing.Image]::FromFile($src)
  $c = New-Canvas $size
  $c[1].DrawImage($img, 0, 0, $size, $size)
  $c[1].Dispose(); $img.Dispose()
  New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
  $c[0].Save($dest, [Drawing.Imaging.ImageFormat]::Png); $c[0].Dispose()
}

$legacySizes = [ordered]@{ 'mdpi' = 48; 'hdpi' = 72; 'xhdpi' = 96; 'xxhdpi' = 144; 'xxxhdpi' = 192 }
$adaptiveSizes = [ordered]@{ 'mdpi' = 108; 'hdpi' = 162; 'xhdpi' = 216; 'xxhdpi' = 324; 'xxxhdpi' = 432 }

foreach ($app in 'app_watch', 'app_mobile') {
  $src = "$root\apps\$app\android\app\src"
  foreach ($flavor in @(@('main', ''), @('dev', '_dev'), @('staging', '_staging'))) {
    foreach ($d in $legacySizes.Keys) {
      Save-Resized "$out\legacy$($flavor[1]).png" "$src\$($flavor[0])\res\mipmap-$d\ic_launcher.png" $legacySizes[$d]
      Save-Resized "$out\foreground$($flavor[1]).png" "$src\$($flavor[0])\res\mipmap-$d\ic_launcher_foreground.png" $adaptiveSizes[$d]
    }
  }
  foreach ($d in $adaptiveSizes.Keys) {
    Save-Resized "$out\monochrome.png" "$src\main\res\mipmap-$d\ic_launcher_monochrome.png" $adaptiveSizes[$d]
  }
  New-Item -ItemType Directory -Force "$src\main\res\mipmap-anydpi-v26" | Out-Null
  [IO.File]::WriteAllText("$src\main\res\mipmap-anydpi-v26\ic_launcher.xml", @'
<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by tool/icons/generate_icon_sources.ps1. Android 8+ adaptive
     icon; monochrome is used for themed icons on Android 13+. -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
'@.Replace("`r`n", "`n"))
  [IO.File]::WriteAllText("$src\main\res\values\ic_launcher_colors.xml", @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
    <!-- Accent of the task notification (brand red, AppColors.brand). -->
    <color name="notification_accent">#E81C2C</color>
</resources>
'@.Replace("`r`n", "`n"))
  # Release builds shrink resources; the notification icon is referenced by
  # name from Dart, so keep it explicitly.
  New-Item -ItemType Directory -Force "$src\main\res\raw" | Out-Null
  [IO.File]::WriteAllText("$src\main\res\raw\keep.xml", @'
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@drawable/ic_stat_task" />
'@.Replace("`r`n", "`n"))
}
"Android launcher and notification resources written."

"Icon sources written to $out (logo source ${side}px)."
