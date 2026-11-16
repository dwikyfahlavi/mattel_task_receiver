# Extracts the technician-app part of the backend OpenAPI document into
# docs/backend/openapi-technician.json (paths + referenced schemas), so the
# contract the app is built against is versioned with the code.
#
# Usage: powershell -File tool/api/extract_openapi.ps1 [-Source <file-or-url>]
param(
  [string]$Source = 'https://api.mattel-dev.altimeda.com/api/docs-json'
)
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..\..')
if ($Source -match '^https?://') {
  $json = (Invoke-WebRequest -UseBasicParsing -Uri $Source).Content
} else {
  $json = Get-Content -Raw $Source
}
$doc = $json | ConvertFrom-Json
$keep = '^/(technicians/me|technician-auth|shared-devices/(me|enroll|pairings))'
$paths = [ordered]@{}
foreach ($p in $doc.paths.PSObject.Properties) {
  if ($p.Name -match $keep) { $paths[$p.Name] = $p.Value }
}
# Collect referenced schemas transitively.
$schemas = [ordered]@{}
$queue = New-Object System.Collections.Queue
function Add-Refs([string]$text) {
  foreach ($m in [regex]::Matches($text, '#/components/schemas/([A-Za-z0-9_]+)')) {
    $n = $m.Groups[1].Value
    if (-not $schemas.Contains($n)) { $schemas[$n] = $null; $queue.Enqueue($n) }
  }
}
Add-Refs (($paths | ConvertTo-Json -Depth 100 -Compress))
while ($queue.Count -gt 0) {
  $n = $queue.Dequeue()
  $s = $doc.components.schemas.$n
  $schemas[$n] = $s
  Add-Refs (($s | ConvertTo-Json -Depth 100 -Compress))
}
$out = [ordered]@{
  openapi = $doc.openapi
  info    = $doc.info
  servers = $doc.servers
  paths   = $paths
  components = [ordered]@{ schemas = $schemas; securitySchemes = $doc.components.securitySchemes }
}
$target = Join-Path $root 'docs\backend\openapi-technician.json'
New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
$out | ConvertTo-Json -Depth 100 | Set-Content -Path $target -Encoding ASCII
Write-Output "Wrote $target ($($paths.Count) paths, $($schemas.Count) schemas)"
