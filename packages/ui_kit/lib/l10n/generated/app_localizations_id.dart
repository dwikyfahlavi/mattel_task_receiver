// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Mattel Task';

  @override
  String get brandName => 'MATTEL';

  @override
  String copyright(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    return '© $yearString Mattel, Inc. Hak cipta dilindungi.';
  }

  @override
  String get actionBack => 'Kembali';

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionRetry => 'Coba Lagi';

  @override
  String get actionClose => 'Tutup';

  @override
  String get actionContinue => 'Lanjut';

  @override
  String get actionBackToHome => 'Kembali ke Beranda';

  @override
  String get actionOpenSettings => 'Buka Pengaturan';

  @override
  String get actionLogout => 'Keluar';

  @override
  String get actionFix => 'Perbaiki';

  @override
  String get actionAllow => 'Izinkan';

  @override
  String get offlineBanner => 'Tidak ada koneksi';

  @override
  String get offlineActionDisabled =>
      'Tidak ada koneksi. Coba lagi saat online.';

  @override
  String get errorGeneric => 'Terjadi kesalahan. Coba lagi.';

  @override
  String get errorDeviceClock => 'Periksa tanggal dan jam perangkat';

  @override
  String get errorSessionExpired => 'Sesi berakhir. Silakan masuk kembali.';

  @override
  String get errorSessionReplaced =>
      'Akun ini masuk di perangkat lain. Silakan masuk kembali.';

  @override
  String get errorRateLimited => 'Terlalu banyak percobaan. Coba lagi nanti.';

  @override
  String errorRateLimitedFor(int minutes) {
    return 'Terlalu banyak percobaan. Coba lagi dalam $minutes menit.';
  }

  @override
  String get errorNotCheckedIn => 'Kamu belum Check In.';

  @override
  String get errorWrongDevice => 'Aksi ini tidak tersedia di perangkat ini.';

  @override
  String get errorDeviceSignature =>
      'Watch tidak dikenali server. Hubungi admin.';

  @override
  String get errorDeviceDisabled =>
      'Watch ini dinonaktifkan admin. Hubungi admin.';

  @override
  String get loginTitle => 'Selamat Datang Kembali';

  @override
  String get loginSubtitle => 'Masukkan detail Anda untuk mengakses akun';

  @override
  String get kpkLabel => 'KPK';

  @override
  String get kpkHint => 'Masukkan nomor KPK Anda';

  @override
  String get kpkInvalid => 'KPK hanya berisi angka (maks. 9 digit)';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Nomor HP yang terdaftar';

  @override
  String get showPassword => 'Tampilkan password';

  @override
  String get hidePassword => 'Sembunyikan password';

  @override
  String get rememberMe => 'Tetap masuk di perangkat ini';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginDivider => 'atau';

  @override
  String get loginAsVendorTechnician => 'Masuk sebagai Vendor Technician';

  @override
  String get loginInvalid => 'KPK atau password salah!';

  @override
  String get watchWelcomeTitle => 'Selamat Datang Kembali';

  @override
  String get watchWelcomeSubtitle => 'Masuk ke akun Anda menggunakan QR Code';

  @override
  String get watchLoginWithQr => 'Masuk dengan QR Code';

  @override
  String get watchScanTitle => 'Scan QR Code';

  @override
  String get watchScanHint => 'Scan dengan aplikasi Mattel Task di HP';

  @override
  String get watchRegenerateQr => 'Buat Ulang QR Code';

  @override
  String get watchQrExpired => 'QR Code kedaluwarsa';

  @override
  String get watchQrOffline => 'Perangkat offline. Periksa Wi-Fi.';

  @override
  String get watchPairing => 'Menghubungkan…';

  @override
  String get enrollTitle => 'Daftarkan Watch';

  @override
  String get enrollSubtitle =>
      'Masukkan atau scan kode pendaftaran dari admin.';

  @override
  String get enrollCodeLabel => 'Kode pendaftaran';

  @override
  String get enrollCodeHint => 'Contoh: K7M2Q9XD4B';

  @override
  String get enrollButton => 'Daftarkan';

  @override
  String get enrollScanButton => 'Scan Kode';

  @override
  String get enrollHardwareHint =>
      'Atau tekan tombol scan untuk membaca QR Code.';

  @override
  String get enrollInvalid =>
      'Kode tidak valid atau kedaluwarsa. Minta kode baru ke admin.';

  @override
  String get enrollKeyFailed =>
      'Kunci keamanan Watch tidak dapat dibuat. Hubungi admin.';

  @override
  String enrollSuccess(String name) {
    return 'Watch terdaftar: $name';
  }

  @override
  String get scanQrButton => 'Scan QR Code';

  @override
  String get scanQrCaption => 'Masuk ke Watch dengan Scan QR Code';

  @override
  String get scannerTitle => 'Scan QR Code Watch';

  @override
  String get scannerHint => 'Arahkan kamera ke QR Code di layar Watch';

  @override
  String get scannerEnrollTitle => 'Scan Kode Pendaftaran';

  @override
  String get scannerEnrollHint => 'Arahkan kamera ke QR Code dari admin';

  @override
  String get scannerZoom => 'Zoom';

  @override
  String get scannerZoomOut => 'Perkecil';

  @override
  String get scannerZoomIn => 'Perbesar';

  @override
  String pairConfirmTitle(String name) {
    return 'Masuk ke $name?';
  }

  @override
  String pairConfirmBody(String location) {
    return 'Lokasi $location. Pastikan nama sama dengan yang tampil di Watch.';
  }

  @override
  String get pairConfirmButton => 'Masuk ke Watch';

  @override
  String get pairChecking => 'Memeriksa QR Code…';

  @override
  String get pairWaiting => 'Menunggu Watch…';

  @override
  String get pairSuccess => 'Watch berhasil terhubung';

  @override
  String get pairCodeInvalid =>
      'QR Code kedaluwarsa. Buat ulang QR Code di Watch.';

  @override
  String get pairInvalidQr => 'QR Code tidak dikenali';

  @override
  String get pairNotWatchCode => 'Ini bukan kode pairing Watch';

  @override
  String get cameraPermissionTitle => 'Izin kamera dibutuhkan';

  @override
  String get cameraPermissionBody => 'Kamera hanya dipakai untuk scan QR Code.';

  @override
  String get roleTechnician => 'Technician';

  @override
  String get statusAvailable => 'AVAILABLE';

  @override
  String get statusUnavailable => 'UNAVAILABLE';

  @override
  String get homeReadyTitle => 'Siap mulai bekerja?';

  @override
  String get homeReadySubtitle =>
      'Lakukan Check In untuk mulai menerima penugasan';

  @override
  String get bannerUnavailableTitle => 'Unavailable';

  @override
  String get bannerUnavailableSubtitle => 'Tidak menerima penugasan';

  @override
  String get bannerAvailableTitle => 'Available';

  @override
  String get bannerAvailableSubtitle => 'Siap menerima penugasan';

  @override
  String get checkInSuccessTitle => 'Check In Berhasil!';

  @override
  String get checkInButton => 'Check In';

  @override
  String get checkOutButton => 'Check Out';

  @override
  String get watchCheckOutButton => 'Check Out atau Unavailable';

  @override
  String get checkOutBlocked => 'Masih ada penugasan yang berjalan';

  @override
  String get checkOutQueued => 'Check Out akan dikirim saat online';

  @override
  String get checkOutConflict => 'Check Out ditolak server. Status diperbarui.';

  @override
  String get historyTooltip => 'Riwayat Penugasan';

  @override
  String get profileTooltip => 'Profil';

  @override
  String get logoutConfirmTitle => 'Keluar?';

  @override
  String get logoutConfirmBody => 'Kamu akan keluar dari perangkat ini.';

  @override
  String get keepAliveTitle => 'Mattel Task aktif';

  @override
  String get keepAliveBody => 'Siap menerima penugasan';

  @override
  String sessionEndsAt(String time) {
    return 'Sesi berakhir pukul $time';
  }

  @override
  String get sessionEndBlocked => 'Selesaikan penugasan untuk mengakhiri sesi';

  @override
  String get sessionEndedTitle => 'Sesi Berakhir';

  @override
  String get sessionEndedBody =>
      'Sesi kerja hari ini telah berakhir. Silakan masuk kembali untuk shift berikutnya.';

  @override
  String get readinessTitle => 'Perangkat belum siap';

  @override
  String get readinessSubtitle => 'Perbaiki hal berikut sebelum Check In';

  @override
  String get readinessWarnTitle => 'Perhatian';

  @override
  String get readinessWarnSubtitle =>
      'Penugasan mungkin terlambat muncul. Kamu tetap bisa Check In.';

  @override
  String get readinessContinue => 'Tetap Check In';

  @override
  String get readinessNetwork => 'Koneksi internet';

  @override
  String get readinessDeviceClock => 'Tanggal dan jam perangkat';

  @override
  String get readinessNotification => 'Izin notifikasi';

  @override
  String get readinessAlertChannel => 'Notifikasi penugasan aktif';

  @override
  String get readinessFullScreen => 'Tampilan layar penuh untuk penugasan';

  @override
  String get readinessRealtime => 'Koneksi ke server penugasan';

  @override
  String get readinessPlayServices => 'Google Play Services';

  @override
  String get readinessBattery => 'Pengecualian optimasi baterai';

  @override
  String get notificationExplainTitle => 'Izinkan notifikasi';

  @override
  String get notificationExplainBody =>
      'Notifikasi dipakai untuk menampilkan penugasan baru, termasuk saat layar terkunci.';

  @override
  String get taskNewTitle => 'Penugasan Baru';

  @override
  String get taskRespondWithin => 'Respon dalam 1 menit';

  @override
  String taskGreeting(String name) {
    return 'Halo, $name. Ada mesin yang membutuhkan penanganan segera:';
  }

  @override
  String get taskInstruction =>
      'Terima jika kamu bisa segera menuju lokasi. Jika tidak, Tolak agar tugas dialihkan ke teknisi lain.';

  @override
  String taskLocation(String location) {
    return 'Lokasi $location';
  }

  @override
  String taskCountdownLabel(int seconds) {
    return 'Sisa waktu $seconds detik';
  }

  @override
  String get taskAccept => 'Terima';

  @override
  String get taskReject => 'Tolak';

  @override
  String get taskHardwareKeyHint => 'Tahan tombol samping untuk Terima';

  @override
  String get taskExpiryChecking => 'Waktu habis. Menunggu konfirmasi server…';

  @override
  String get rejectConfirmTitle => 'Tolak Penugasan?';

  @override
  String get rejectConfirmBody =>
      'Task akan dialihkan ke teknisi lain dan kamu perlu Check In ulang.';

  @override
  String get acceptedTitle => 'Penugasan Diterima!';

  @override
  String get acceptedSubtitle =>
      'Segera menuju lokasi dan tangani masalah tersebut';

  @override
  String get acceptedDetailSubtitle => 'Baca detail penugasan dengan teliti';

  @override
  String get acceptedTime => 'Waktu Diterima';

  @override
  String get acceptedInfo =>
      'Penugasan selesai otomatis setelah perbaikan dicatat di sistem.';

  @override
  String get reassignedTitle => 'Penugasan Dialihkan!';

  @override
  String reassignedBody(String name) {
    return 'Halo, $name. Karena kamu menolak penugasan, tugas ini telah dialihkan ke teknisi lain.';
  }

  @override
  String get timeoutTitle => 'Waktu Habis!';

  @override
  String timeoutBody(String name) {
    return 'Halo, $name. Karena tidak ada respon, tugas ini telah dialihkan ke teknisi lain.';
  }

  @override
  String get lateDeliveryBody =>
      'Penugasan masuk terlambat dan sudah dialihkan ke teknisi lain. Periksa koneksi perangkat.';

  @override
  String get offlineMissedTitle => 'Penugasan Terlewat';

  @override
  String get offlineMissedBody =>
      'Perangkat tidak terhubung saat penugasan masuk. Tugas ini telah dialihkan.';

  @override
  String get cancelledTitle => 'Penugasan Dibatalkan';

  @override
  String cancelledBody(String name) {
    return 'Halo, $name. Kamu membatalkan penugasan ini dan tugas telah dialihkan ke teknisi lain.';
  }

  @override
  String get checkInAgainInfo =>
      'Untuk menerima penugasan kembali, silakan lakukan Check In ulang dengan menekan tombol di bawah.';

  @override
  String get inProgressTitle => 'Penugasan Berjalan';

  @override
  String get inProgressBody =>
      'Penugasan selesai otomatis setelah perbaikan dicatat.';

  @override
  String get cancelTaskButton => 'Batalkan Penugasan';

  @override
  String get cancelTaskConfirmTitle => 'Batalkan Penugasan?';

  @override
  String get cancelTaskConfirmBody =>
      'Gunakan hanya jika ada kendala. Tugas akan dialihkan dan kamu perlu Check In ulang.';

  @override
  String get taskAlreadyResolved =>
      'Penugasan sudah ditangani di perangkat lain atau waktu habis.';

  @override
  String get taskAcceptedElsewhere => 'Penugasan diterima di perangkat lain.';

  @override
  String get taskCompleted => 'Perbaikan selesai dicatat. Penugasan selesai.';

  @override
  String get taskConflict => 'Status penugasan berubah. Data diperbarui.';

  @override
  String get historyTitle => 'Riwayat Penugasan';

  @override
  String get historyFilterAll => 'Semua';

  @override
  String get historyWaiting => 'Menunggu';

  @override
  String get historyInProgress => 'In Progress';

  @override
  String get historyDone => 'Selesai';

  @override
  String get historyMissed => 'Ditolak/Habis Waktu';

  @override
  String get historyCancelled => 'Dibatalkan';

  @override
  String get historyEmpty => 'Belum ada riwayat penugasan';

  @override
  String get historyLoadFailed => 'Gagal memuat riwayat';

  @override
  String get historyReasonDeclined =>
      'Ditolak, dibatalkan atau tidak ada respon';

  @override
  String get historyReasonCancelled => 'Perbaikan selesai tanpa teknisi';

  @override
  String get workOrderDetailTitle => 'Detail Penugasan';

  @override
  String get workOrderNotFound => 'Penugasan tidak ditemukan';

  @override
  String get detailRequestId => 'No. Penugasan';

  @override
  String get detailShift => 'Shift';

  @override
  String get detailMachineType => 'Tipe Mesin';

  @override
  String get detailCreatedAt => 'Dibuat';

  @override
  String get detailProblemStarted => 'Masalah Dimulai';

  @override
  String get detailActionStarted => 'Penanganan Dimulai';

  @override
  String get detailFinishedAt => 'Selesai';

  @override
  String get detailRepairReason => 'Penyebab';

  @override
  String get detailAction => 'Tindakan';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileKpk => 'KPK';

  @override
  String get profileShift => 'Shift';

  @override
  String get profileMemberSince => 'Bergabung sejak';

  @override
  String get profilePhone => 'Nomor HP';

  @override
  String get profileStatus => 'Status Akun';

  @override
  String get profileActive => 'Aktif';

  @override
  String get profileInactive => 'Tidak aktif';

  @override
  String get profileLoadFailed => 'Gagal memuat profil';

  @override
  String get profileAttendance => 'Riwayat Kehadiran';

  @override
  String get myWatchesTitle => 'Watch Saya';

  @override
  String get myWatchesEmpty => 'Tidak ada Watch yang terhubung';

  @override
  String get myWatchesLoadFailed => 'Gagal memuat daftar Watch';

  @override
  String watchPairedSince(String time) {
    return 'Terhubung $time';
  }

  @override
  String get unpairButton => 'Putuskan';

  @override
  String unpairConfirmTitle(String name) {
    return 'Putuskan $name?';
  }

  @override
  String get unpairConfirmBody => 'Watch akan keluar dan kamu akan Check Out.';

  @override
  String get unpairDone => 'Watch diputuskan';

  @override
  String get watchUnnamed => 'Watch';

  @override
  String get attendanceTitle => 'Riwayat Kehadiran';

  @override
  String get attendanceEmpty => 'Belum ada riwayat kehadiran';

  @override
  String get attendanceLoadFailed => 'Gagal memuat riwayat kehadiran';

  @override
  String get attendanceOpen => 'Masih Check In';

  @override
  String attendanceWorked(int hours, int minutes) {
    return '$hours jam $minutes menit';
  }

  @override
  String get attendanceCheckIn => 'Check In';

  @override
  String get attendanceCheckOut => 'Check Out';

  @override
  String get updateTitle => 'Perbarui Aplikasi';

  @override
  String get updateForceBody =>
      'Versi aplikasi ini sudah tidak didukung. Perbarui aplikasi untuk melanjutkan.';

  @override
  String get updateSoftBody =>
      'Versi baru aplikasi tersedia. Perbarui sekarang?';

  @override
  String get updateNow => 'Perbarui Sekarang';

  @override
  String get updateLater => 'Nanti';

  @override
  String updateDownloading(int percent) {
    return 'Mengunduh pembaruan… $percent%';
  }

  @override
  String get updateManaged =>
      'Pembaruan akan dipasang otomatis oleh admin perangkat. Hubungi supervisor jika aplikasi tetap terkunci.';

  @override
  String get updateFailed => 'Pembaruan gagal. Coba lagi.';

  @override
  String get updateInstallPermission =>
      'Izinkan pemasangan aplikasi dari sumber ini untuk melanjutkan.';
}
