import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('id')];

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'Mattel Task'**
  String get appName;

  /// No description provided for @brandName.
  ///
  /// In id, this message translates to:
  /// **'MATTEL'**
  String get brandName;

  /// No description provided for @copyright.
  ///
  /// In id, this message translates to:
  /// **'© {year} Mattel, Inc. Hak cipta dilindungi.'**
  String copyright(int year);

  /// No description provided for @actionBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get actionBack;

  /// No description provided for @actionCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get actionRetry;

  /// No description provided for @actionClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get actionClose;

  /// No description provided for @actionContinue.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get actionContinue;

  /// No description provided for @actionBackToHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Beranda'**
  String get actionBackToHome;

  /// No description provided for @actionOpenSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka Pengaturan'**
  String get actionOpenSettings;

  /// No description provided for @actionLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get actionLogout;

  /// No description provided for @actionFix.
  ///
  /// In id, this message translates to:
  /// **'Perbaiki'**
  String get actionFix;

  /// No description provided for @actionAllow.
  ///
  /// In id, this message translates to:
  /// **'Izinkan'**
  String get actionAllow;

  /// No description provided for @offlineBanner.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi'**
  String get offlineBanner;

  /// No description provided for @offlineActionDisabled.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi. Coba lagi saat online.'**
  String get offlineActionDisabled;

  /// No description provided for @errorGeneric.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorGeneric;

  /// No description provided for @errorDeviceClock.
  ///
  /// In id, this message translates to:
  /// **'Periksa tanggal dan jam perangkat'**
  String get errorDeviceClock;

  /// No description provided for @errorSessionExpired.
  ///
  /// In id, this message translates to:
  /// **'Sesi berakhir. Silakan masuk kembali.'**
  String get errorSessionExpired;

  /// No description provided for @errorSessionReplaced.
  ///
  /// In id, this message translates to:
  /// **'Akun ini masuk di perangkat lain. Silakan masuk kembali.'**
  String get errorSessionReplaced;

  /// No description provided for @errorRateLimited.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan. Coba lagi nanti.'**
  String get errorRateLimited;

  /// No description provided for @errorRateLimitedFor.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan. Coba lagi dalam {minutes} menit.'**
  String errorRateLimitedFor(int minutes);

  /// No description provided for @errorNotCheckedIn.
  ///
  /// In id, this message translates to:
  /// **'Kamu belum Check In.'**
  String get errorNotCheckedIn;

  /// No description provided for @errorWrongDevice.
  ///
  /// In id, this message translates to:
  /// **'Aksi ini tidak tersedia di perangkat ini.'**
  String get errorWrongDevice;

  /// No description provided for @errorDeviceSignature.
  ///
  /// In id, this message translates to:
  /// **'Watch tidak dikenali server. Hubungi admin.'**
  String get errorDeviceSignature;

  /// No description provided for @errorDeviceDisabled.
  ///
  /// In id, this message translates to:
  /// **'Watch ini dinonaktifkan admin. Hubungi admin.'**
  String get errorDeviceDisabled;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang Kembali'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan detail Anda untuk mengakses akun'**
  String get loginSubtitle;

  /// No description provided for @kpkLabel.
  ///
  /// In id, this message translates to:
  /// **'KPK'**
  String get kpkLabel;

  /// No description provided for @kpkHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nomor KPK Anda'**
  String get kpkHint;

  /// No description provided for @kpkInvalid.
  ///
  /// In id, this message translates to:
  /// **'KPK hanya berisi angka (maks. 9 digit)'**
  String get kpkInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP yang terdaftar'**
  String get passwordHint;

  /// No description provided for @showPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan password'**
  String get hidePassword;

  /// No description provided for @rememberMe.
  ///
  /// In id, this message translates to:
  /// **'Tetap masuk di perangkat ini'**
  String get rememberMe;

  /// No description provided for @loginButton.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginButton;

  /// No description provided for @loginDivider.
  ///
  /// In id, this message translates to:
  /// **'atau'**
  String get loginDivider;

  /// No description provided for @loginAsVendorTechnician.
  ///
  /// In id, this message translates to:
  /// **'Masuk sebagai Vendor Technician'**
  String get loginAsVendorTechnician;

  /// No description provided for @loginInvalid.
  ///
  /// In id, this message translates to:
  /// **'KPK atau password salah!'**
  String get loginInvalid;

  /// No description provided for @watchWelcomeTitle.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang Kembali'**
  String get watchWelcomeTitle;

  /// No description provided for @watchWelcomeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke akun Anda menggunakan QR Code'**
  String get watchWelcomeSubtitle;

  /// No description provided for @watchLoginWithQr.
  ///
  /// In id, this message translates to:
  /// **'Masuk dengan QR Code'**
  String get watchLoginWithQr;

  /// No description provided for @watchScanTitle.
  ///
  /// In id, this message translates to:
  /// **'Scan QR Code'**
  String get watchScanTitle;

  /// No description provided for @watchScanHint.
  ///
  /// In id, this message translates to:
  /// **'Scan dengan aplikasi Mattel Task di HP'**
  String get watchScanHint;

  /// No description provided for @watchRegenerateQr.
  ///
  /// In id, this message translates to:
  /// **'Buat Ulang QR Code'**
  String get watchRegenerateQr;

  /// No description provided for @watchQrExpired.
  ///
  /// In id, this message translates to:
  /// **'QR Code kedaluwarsa'**
  String get watchQrExpired;

  /// No description provided for @watchQrOffline.
  ///
  /// In id, this message translates to:
  /// **'Perangkat offline. Periksa Wi-Fi.'**
  String get watchQrOffline;

  /// No description provided for @watchPairing.
  ///
  /// In id, this message translates to:
  /// **'Menghubungkan…'**
  String get watchPairing;

  /// No description provided for @enrollTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftarkan Watch'**
  String get enrollTitle;

  /// No description provided for @enrollSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan atau scan kode pendaftaran dari admin.'**
  String get enrollSubtitle;

  /// No description provided for @enrollCodeLabel.
  ///
  /// In id, this message translates to:
  /// **'Kode pendaftaran'**
  String get enrollCodeLabel;

  /// No description provided for @enrollCodeHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: K7M2Q9XD4B'**
  String get enrollCodeHint;

  /// No description provided for @enrollButton.
  ///
  /// In id, this message translates to:
  /// **'Daftarkan'**
  String get enrollButton;

  /// No description provided for @enrollScanButton.
  ///
  /// In id, this message translates to:
  /// **'Scan Kode'**
  String get enrollScanButton;

  /// No description provided for @enrollHardwareHint.
  ///
  /// In id, this message translates to:
  /// **'Atau tekan tombol scan untuk membaca QR Code.'**
  String get enrollHardwareHint;

  /// No description provided for @enrollInvalid.
  ///
  /// In id, this message translates to:
  /// **'Kode tidak valid atau kedaluwarsa. Minta kode baru ke admin.'**
  String get enrollInvalid;

  /// No description provided for @enrollKeyFailed.
  ///
  /// In id, this message translates to:
  /// **'Kunci keamanan Watch tidak dapat dibuat. Hubungi admin.'**
  String get enrollKeyFailed;

  /// No description provided for @enrollSuccess.
  ///
  /// In id, this message translates to:
  /// **'Watch terdaftar: {name}'**
  String enrollSuccess(String name);

  /// No description provided for @scanQrButton.
  ///
  /// In id, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrButton;

  /// No description provided for @scanQrCaption.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke Watch dengan Scan QR Code'**
  String get scanQrCaption;

  /// No description provided for @scannerTitle.
  ///
  /// In id, this message translates to:
  /// **'Scan QR Code Watch'**
  String get scannerTitle;

  /// No description provided for @scannerHint.
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke QR Code di layar Watch'**
  String get scannerHint;

  /// No description provided for @scannerEnrollTitle.
  ///
  /// In id, this message translates to:
  /// **'Scan Kode Pendaftaran'**
  String get scannerEnrollTitle;

  /// No description provided for @scannerEnrollHint.
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke QR Code dari admin'**
  String get scannerEnrollHint;

  /// No description provided for @scannerZoom.
  ///
  /// In id, this message translates to:
  /// **'Zoom'**
  String get scannerZoom;

  /// No description provided for @scannerZoomOut.
  ///
  /// In id, this message translates to:
  /// **'Perkecil'**
  String get scannerZoomOut;

  /// No description provided for @scannerZoomIn.
  ///
  /// In id, this message translates to:
  /// **'Perbesar'**
  String get scannerZoomIn;

  /// No description provided for @pairConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke {name}?'**
  String pairConfirmTitle(String name);

  /// No description provided for @pairConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Lokasi {location}. Pastikan nama sama dengan yang tampil di Watch.'**
  String pairConfirmBody(String location);

  /// No description provided for @pairConfirmButton.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke Watch'**
  String get pairConfirmButton;

  /// No description provided for @pairChecking.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa QR Code…'**
  String get pairChecking;

  /// No description provided for @pairWaiting.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Watch…'**
  String get pairWaiting;

  /// No description provided for @pairSuccess.
  ///
  /// In id, this message translates to:
  /// **'Watch berhasil terhubung'**
  String get pairSuccess;

  /// No description provided for @pairCodeInvalid.
  ///
  /// In id, this message translates to:
  /// **'QR Code kedaluwarsa. Buat ulang QR Code di Watch.'**
  String get pairCodeInvalid;

  /// No description provided for @pairInvalidQr.
  ///
  /// In id, this message translates to:
  /// **'QR Code tidak dikenali'**
  String get pairInvalidQr;

  /// No description provided for @pairNotWatchCode.
  ///
  /// In id, this message translates to:
  /// **'Ini bukan kode pairing Watch'**
  String get pairNotWatchCode;

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In id, this message translates to:
  /// **'Izin kamera dibutuhkan'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraPermissionBody.
  ///
  /// In id, this message translates to:
  /// **'Kamera hanya dipakai untuk scan QR Code.'**
  String get cameraPermissionBody;

  /// No description provided for @roleTechnician.
  ///
  /// In id, this message translates to:
  /// **'Technician'**
  String get roleTechnician;

  /// No description provided for @statusAvailable.
  ///
  /// In id, this message translates to:
  /// **'AVAILABLE'**
  String get statusAvailable;

  /// No description provided for @statusUnavailable.
  ///
  /// In id, this message translates to:
  /// **'UNAVAILABLE'**
  String get statusUnavailable;

  /// No description provided for @homeReadyTitle.
  ///
  /// In id, this message translates to:
  /// **'Siap mulai bekerja?'**
  String get homeReadyTitle;

  /// No description provided for @homeReadySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lakukan Check In untuk mulai menerima penugasan'**
  String get homeReadySubtitle;

  /// No description provided for @bannerUnavailableTitle.
  ///
  /// In id, this message translates to:
  /// **'Unavailable'**
  String get bannerUnavailableTitle;

  /// No description provided for @bannerUnavailableSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak menerima penugasan'**
  String get bannerUnavailableSubtitle;

  /// No description provided for @bannerAvailableTitle.
  ///
  /// In id, this message translates to:
  /// **'Available'**
  String get bannerAvailableTitle;

  /// No description provided for @bannerAvailableSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Siap menerima penugasan'**
  String get bannerAvailableSubtitle;

  /// No description provided for @checkInSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Check In Berhasil!'**
  String get checkInSuccessTitle;

  /// No description provided for @checkInButton.
  ///
  /// In id, this message translates to:
  /// **'Check In'**
  String get checkInButton;

  /// No description provided for @checkOutButton.
  ///
  /// In id, this message translates to:
  /// **'Check Out'**
  String get checkOutButton;

  /// No description provided for @watchCheckOutButton.
  ///
  /// In id, this message translates to:
  /// **'Check Out atau Unavailable'**
  String get watchCheckOutButton;

  /// No description provided for @checkOutBlocked.
  ///
  /// In id, this message translates to:
  /// **'Masih ada penugasan yang berjalan'**
  String get checkOutBlocked;

  /// No description provided for @checkOutQueued.
  ///
  /// In id, this message translates to:
  /// **'Check Out akan dikirim saat online'**
  String get checkOutQueued;

  /// No description provided for @checkOutConflict.
  ///
  /// In id, this message translates to:
  /// **'Check Out ditolak server. Status diperbarui.'**
  String get checkOutConflict;

  /// No description provided for @historyTooltip.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Penugasan'**
  String get historyTooltip;

  /// No description provided for @profileTooltip.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTooltip;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Kamu akan keluar dari perangkat ini.'**
  String get logoutConfirmBody;

  /// No description provided for @keepAliveTitle.
  ///
  /// In id, this message translates to:
  /// **'Mattel Task aktif'**
  String get keepAliveTitle;

  /// No description provided for @keepAliveBody.
  ///
  /// In id, this message translates to:
  /// **'Siap menerima penugasan'**
  String get keepAliveBody;

  /// No description provided for @sessionEndsAt.
  ///
  /// In id, this message translates to:
  /// **'Sesi berakhir pukul {time}'**
  String sessionEndsAt(String time);

  /// No description provided for @sessionEndBlocked.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan penugasan untuk mengakhiri sesi'**
  String get sessionEndBlocked;

  /// No description provided for @sessionEndedTitle.
  ///
  /// In id, this message translates to:
  /// **'Sesi Berakhir'**
  String get sessionEndedTitle;

  /// No description provided for @sessionEndedBody.
  ///
  /// In id, this message translates to:
  /// **'Sesi kerja hari ini telah berakhir. Silakan masuk kembali untuk shift berikutnya.'**
  String get sessionEndedBody;

  /// No description provided for @readinessTitle.
  ///
  /// In id, this message translates to:
  /// **'Perangkat belum siap'**
  String get readinessTitle;

  /// No description provided for @readinessSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Perbaiki hal berikut sebelum Check In'**
  String get readinessSubtitle;

  /// No description provided for @readinessWarnTitle.
  ///
  /// In id, this message translates to:
  /// **'Perhatian'**
  String get readinessWarnTitle;

  /// No description provided for @readinessWarnSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan mungkin terlambat muncul. Kamu tetap bisa Check In.'**
  String get readinessWarnSubtitle;

  /// No description provided for @readinessContinue.
  ///
  /// In id, this message translates to:
  /// **'Tetap Check In'**
  String get readinessContinue;

  /// No description provided for @readinessNetwork.
  ///
  /// In id, this message translates to:
  /// **'Koneksi internet'**
  String get readinessNetwork;

  /// No description provided for @readinessDeviceClock.
  ///
  /// In id, this message translates to:
  /// **'Tanggal dan jam perangkat'**
  String get readinessDeviceClock;

  /// No description provided for @readinessNotification.
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi'**
  String get readinessNotification;

  /// No description provided for @readinessAlertChannel.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi penugasan aktif'**
  String get readinessAlertChannel;

  /// No description provided for @readinessFullScreen.
  ///
  /// In id, this message translates to:
  /// **'Tampilan layar penuh untuk penugasan'**
  String get readinessFullScreen;

  /// No description provided for @readinessRealtime.
  ///
  /// In id, this message translates to:
  /// **'Koneksi ke server penugasan'**
  String get readinessRealtime;

  /// No description provided for @readinessPlayServices.
  ///
  /// In id, this message translates to:
  /// **'Google Play Services'**
  String get readinessPlayServices;

  /// No description provided for @readinessBattery.
  ///
  /// In id, this message translates to:
  /// **'Pengecualian optimasi baterai'**
  String get readinessBattery;

  /// No description provided for @notificationExplainTitle.
  ///
  /// In id, this message translates to:
  /// **'Izinkan notifikasi'**
  String get notificationExplainTitle;

  /// No description provided for @notificationExplainBody.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi dipakai untuk menampilkan penugasan baru, termasuk saat layar terkunci.'**
  String get notificationExplainBody;

  /// No description provided for @taskNewTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Baru'**
  String get taskNewTitle;

  /// No description provided for @taskRespondWithin.
  ///
  /// In id, this message translates to:
  /// **'Respon dalam 1 menit'**
  String get taskRespondWithin;

  /// No description provided for @taskGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}. Ada mesin yang membutuhkan penanganan segera:'**
  String taskGreeting(String name);

  /// No description provided for @taskInstruction.
  ///
  /// In id, this message translates to:
  /// **'Terima jika kamu bisa segera menuju lokasi. Jika tidak, Tolak agar tugas dialihkan ke teknisi lain.'**
  String get taskInstruction;

  /// No description provided for @taskLocation.
  ///
  /// In id, this message translates to:
  /// **'Lokasi {location}'**
  String taskLocation(String location);

  /// No description provided for @taskCountdownLabel.
  ///
  /// In id, this message translates to:
  /// **'Sisa waktu {seconds} detik'**
  String taskCountdownLabel(int seconds);

  /// No description provided for @taskAccept.
  ///
  /// In id, this message translates to:
  /// **'Terima'**
  String get taskAccept;

  /// No description provided for @taskReject.
  ///
  /// In id, this message translates to:
  /// **'Tolak'**
  String get taskReject;

  /// No description provided for @taskHardwareKeyHint.
  ///
  /// In id, this message translates to:
  /// **'Tahan tombol samping untuk Terima'**
  String get taskHardwareKeyHint;

  /// No description provided for @taskExpiryChecking.
  ///
  /// In id, this message translates to:
  /// **'Waktu habis. Menunggu konfirmasi server…'**
  String get taskExpiryChecking;

  /// No description provided for @rejectConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Tolak Penugasan?'**
  String get rejectConfirmTitle;

  /// No description provided for @rejectConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Task akan dialihkan ke teknisi lain dan kamu perlu Check In ulang.'**
  String get rejectConfirmBody;

  /// No description provided for @acceptedTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Diterima!'**
  String get acceptedTitle;

  /// No description provided for @acceptedSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Segera menuju lokasi dan tangani masalah tersebut'**
  String get acceptedSubtitle;

  /// No description provided for @acceptedDetailSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Baca detail penugasan dengan teliti'**
  String get acceptedDetailSubtitle;

  /// No description provided for @acceptedTime.
  ///
  /// In id, this message translates to:
  /// **'Waktu Diterima'**
  String get acceptedTime;

  /// No description provided for @acceptedInfo.
  ///
  /// In id, this message translates to:
  /// **'Penugasan selesai otomatis setelah perbaikan dicatat di sistem.'**
  String get acceptedInfo;

  /// No description provided for @reassignedTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Dialihkan!'**
  String get reassignedTitle;

  /// No description provided for @reassignedBody.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}. Karena kamu menolak penugasan, tugas ini telah dialihkan ke teknisi lain.'**
  String reassignedBody(String name);

  /// No description provided for @timeoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Waktu Habis!'**
  String get timeoutTitle;

  /// No description provided for @timeoutBody.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}. Karena tidak ada respon, tugas ini telah dialihkan ke teknisi lain.'**
  String timeoutBody(String name);

  /// No description provided for @lateDeliveryBody.
  ///
  /// In id, this message translates to:
  /// **'Penugasan masuk terlambat dan sudah dialihkan ke teknisi lain. Periksa koneksi perangkat.'**
  String get lateDeliveryBody;

  /// No description provided for @offlineMissedTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Terlewat'**
  String get offlineMissedTitle;

  /// No description provided for @offlineMissedBody.
  ///
  /// In id, this message translates to:
  /// **'Perangkat tidak terhubung saat penugasan masuk. Tugas ini telah dialihkan.'**
  String get offlineMissedBody;

  /// No description provided for @cancelledTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Dibatalkan'**
  String get cancelledTitle;

  /// No description provided for @cancelledBody.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}. Kamu membatalkan penugasan ini dan tugas telah dialihkan ke teknisi lain.'**
  String cancelledBody(String name);

  /// No description provided for @checkInAgainInfo.
  ///
  /// In id, this message translates to:
  /// **'Untuk menerima penugasan kembali, silakan lakukan Check In ulang dengan menekan tombol di bawah.'**
  String get checkInAgainInfo;

  /// No description provided for @inProgressTitle.
  ///
  /// In id, this message translates to:
  /// **'Penugasan Berjalan'**
  String get inProgressTitle;

  /// No description provided for @inProgressBody.
  ///
  /// In id, this message translates to:
  /// **'Penugasan selesai otomatis setelah perbaikan dicatat.'**
  String get inProgressBody;

  /// No description provided for @cancelTaskButton.
  ///
  /// In id, this message translates to:
  /// **'Batalkan Penugasan'**
  String get cancelTaskButton;

  /// No description provided for @cancelTaskConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Batalkan Penugasan?'**
  String get cancelTaskConfirmTitle;

  /// No description provided for @cancelTaskConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Gunakan hanya jika ada kendala. Tugas akan dialihkan dan kamu perlu Check In ulang.'**
  String get cancelTaskConfirmBody;

  /// No description provided for @taskAlreadyResolved.
  ///
  /// In id, this message translates to:
  /// **'Penugasan sudah ditangani di perangkat lain atau waktu habis.'**
  String get taskAlreadyResolved;

  /// No description provided for @taskAcceptedElsewhere.
  ///
  /// In id, this message translates to:
  /// **'Penugasan diterima di perangkat lain.'**
  String get taskAcceptedElsewhere;

  /// No description provided for @taskCompleted.
  ///
  /// In id, this message translates to:
  /// **'Perbaikan selesai dicatat. Penugasan selesai.'**
  String get taskCompleted;

  /// No description provided for @taskConflict.
  ///
  /// In id, this message translates to:
  /// **'Status penugasan berubah. Data diperbarui.'**
  String get taskConflict;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Penugasan'**
  String get historyTitle;

  /// No description provided for @historyFilterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get historyFilterAll;

  /// No description provided for @historyWaiting.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get historyWaiting;

  /// No description provided for @historyInProgress.
  ///
  /// In id, this message translates to:
  /// **'In Progress'**
  String get historyInProgress;

  /// No description provided for @historyDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get historyDone;

  /// No description provided for @historyMissed.
  ///
  /// In id, this message translates to:
  /// **'Ditolak/Habis Waktu'**
  String get historyMissed;

  /// No description provided for @historyCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get historyCancelled;

  /// No description provided for @historyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat penugasan'**
  String get historyEmpty;

  /// No description provided for @historyLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat riwayat'**
  String get historyLoadFailed;

  /// No description provided for @historyReasonDeclined.
  ///
  /// In id, this message translates to:
  /// **'Ditolak, dibatalkan atau tidak ada respon'**
  String get historyReasonDeclined;

  /// No description provided for @historyReasonCancelled.
  ///
  /// In id, this message translates to:
  /// **'Perbaikan selesai tanpa teknisi'**
  String get historyReasonCancelled;

  /// No description provided for @workOrderDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Penugasan'**
  String get workOrderDetailTitle;

  /// No description provided for @workOrderNotFound.
  ///
  /// In id, this message translates to:
  /// **'Penugasan tidak ditemukan'**
  String get workOrderNotFound;

  /// No description provided for @detailRequestId.
  ///
  /// In id, this message translates to:
  /// **'No. Penugasan'**
  String get detailRequestId;

  /// No description provided for @detailShift.
  ///
  /// In id, this message translates to:
  /// **'Shift'**
  String get detailShift;

  /// No description provided for @detailMachineType.
  ///
  /// In id, this message translates to:
  /// **'Tipe Mesin'**
  String get detailMachineType;

  /// No description provided for @detailCreatedAt.
  ///
  /// In id, this message translates to:
  /// **'Dibuat'**
  String get detailCreatedAt;

  /// No description provided for @detailProblemStarted.
  ///
  /// In id, this message translates to:
  /// **'Masalah Dimulai'**
  String get detailProblemStarted;

  /// No description provided for @detailActionStarted.
  ///
  /// In id, this message translates to:
  /// **'Penanganan Dimulai'**
  String get detailActionStarted;

  /// No description provided for @detailFinishedAt.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get detailFinishedAt;

  /// No description provided for @detailRepairReason.
  ///
  /// In id, this message translates to:
  /// **'Penyebab'**
  String get detailRepairReason;

  /// No description provided for @detailAction.
  ///
  /// In id, this message translates to:
  /// **'Tindakan'**
  String get detailAction;

  /// No description provided for @profileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileKpk.
  ///
  /// In id, this message translates to:
  /// **'KPK'**
  String get profileKpk;

  /// No description provided for @profileShift.
  ///
  /// In id, this message translates to:
  /// **'Shift'**
  String get profileShift;

  /// No description provided for @profileMemberSince.
  ///
  /// In id, this message translates to:
  /// **'Bergabung sejak'**
  String get profileMemberSince;

  /// No description provided for @profilePhone.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP'**
  String get profilePhone;

  /// No description provided for @profileStatus.
  ///
  /// In id, this message translates to:
  /// **'Status Akun'**
  String get profileStatus;

  /// No description provided for @profileActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get profileActive;

  /// No description provided for @profileInactive.
  ///
  /// In id, this message translates to:
  /// **'Tidak aktif'**
  String get profileInactive;

  /// No description provided for @profileLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat profil'**
  String get profileLoadFailed;

  /// No description provided for @profileAttendance.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Kehadiran'**
  String get profileAttendance;

  /// No description provided for @myWatchesTitle.
  ///
  /// In id, this message translates to:
  /// **'Watch Saya'**
  String get myWatchesTitle;

  /// No description provided for @myWatchesEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada Watch yang terhubung'**
  String get myWatchesEmpty;

  /// No description provided for @myWatchesLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat daftar Watch'**
  String get myWatchesLoadFailed;

  /// No description provided for @watchPairedSince.
  ///
  /// In id, this message translates to:
  /// **'Terhubung {time}'**
  String watchPairedSince(String time);

  /// No description provided for @unpairButton.
  ///
  /// In id, this message translates to:
  /// **'Putuskan'**
  String get unpairButton;

  /// No description provided for @unpairConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Putuskan {name}?'**
  String unpairConfirmTitle(String name);

  /// No description provided for @unpairConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Watch akan keluar dan kamu akan Check Out.'**
  String get unpairConfirmBody;

  /// No description provided for @unpairDone.
  ///
  /// In id, this message translates to:
  /// **'Watch diputuskan'**
  String get unpairDone;

  /// No description provided for @watchUnnamed.
  ///
  /// In id, this message translates to:
  /// **'Watch'**
  String get watchUnnamed;

  /// No description provided for @attendanceTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Kehadiran'**
  String get attendanceTitle;

  /// No description provided for @attendanceEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat kehadiran'**
  String get attendanceEmpty;

  /// No description provided for @attendanceLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat riwayat kehadiran'**
  String get attendanceLoadFailed;

  /// No description provided for @attendanceOpen.
  ///
  /// In id, this message translates to:
  /// **'Masih Check In'**
  String get attendanceOpen;

  /// No description provided for @attendanceWorked.
  ///
  /// In id, this message translates to:
  /// **'{hours} jam {minutes} menit'**
  String attendanceWorked(int hours, int minutes);

  /// No description provided for @attendanceCheckIn.
  ///
  /// In id, this message translates to:
  /// **'Check In'**
  String get attendanceCheckIn;

  /// No description provided for @attendanceCheckOut.
  ///
  /// In id, this message translates to:
  /// **'Check Out'**
  String get attendanceCheckOut;

  /// No description provided for @updateTitle.
  ///
  /// In id, this message translates to:
  /// **'Perbarui Aplikasi'**
  String get updateTitle;

  /// No description provided for @updateForceBody.
  ///
  /// In id, this message translates to:
  /// **'Versi aplikasi ini sudah tidak didukung. Perbarui aplikasi untuk melanjutkan.'**
  String get updateForceBody;

  /// No description provided for @updateSoftBody.
  ///
  /// In id, this message translates to:
  /// **'Versi baru aplikasi tersedia. Perbarui sekarang?'**
  String get updateSoftBody;

  /// No description provided for @updateNow.
  ///
  /// In id, this message translates to:
  /// **'Perbarui Sekarang'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In id, this message translates to:
  /// **'Nanti'**
  String get updateLater;

  /// No description provided for @updateDownloading.
  ///
  /// In id, this message translates to:
  /// **'Mengunduh pembaruan… {percent}%'**
  String updateDownloading(int percent);

  /// No description provided for @updateManaged.
  ///
  /// In id, this message translates to:
  /// **'Pembaruan akan dipasang otomatis oleh admin perangkat. Hubungi supervisor jika aplikasi tetap terkunci.'**
  String get updateManaged;

  /// No description provided for @updateFailed.
  ///
  /// In id, this message translates to:
  /// **'Pembaruan gagal. Coba lagi.'**
  String get updateFailed;

  /// No description provided for @updateInstallPermission.
  ///
  /// In id, this message translates to:
  /// **'Izinkan pemasangan aplikasi dari sumber ini untuk melanjutkan.'**
  String get updateInstallPermission;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
