import 'app_localizations.dart';

/// Ek metinler için basit, el ile tanımlanmış çeviriler.
///
/// Not: Şu an sadece 'tr' ve 'en' destekleniyor. Diğer locale'ler için
/// varsayılan olarak Türkçe metinler döner.
extension AppLocalizationsExtra on AppLocalizations {
  String get authLoginTab => localeName == 'en' ? 'Log in' : 'Giriş Yap';
  String get authSignUpTab => localeName == 'en' ? 'Sign up' : 'Kayıt Ol';
  String get authEmailHint => 'email@domain.com';
  String get authPasswordHint => localeName == 'en' ? 'Password' : 'Şifre';
  String get authForgotPassword =>
      localeName == 'en' ? 'Forgot password' : 'Şifremi unuttum';
  String get authContinueButton =>
      localeName == 'en' ? 'Continue' : 'Devam Et';
  String get authOr => localeName == 'en' ? 'or' : 'veya';
  String get authContinueWithGoogle =>
      localeName == 'en' ? 'Continue with Google' : 'Google ile Devam Et';
  String get authTerms => localeName == 'en'
      ? 'By continuing, you agree to the Terms of Use and Privacy Policy.'
      : 'Devam ederek Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz';
  String get authForgotPasswordTitle =>
      localeName == 'en' ? 'Forgot password' : 'Şifremi Unuttum';
  String get authForgotPasswordDescription => localeName == 'en'
      ? 'Enter your email address and we\'ll send you a reset link.'
      : 'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.';
  String get authEmailRequired => localeName == 'en'
      ? 'Please enter your email address'
      : 'Lütfen e-posta adresinizi girin';
  String get authEmailInvalid => localeName == 'en'
      ? 'Please enter a valid email address'
      : 'Geçerli bir e-posta adresi girin';
  String get authPasswordRequired => localeName == 'en'
      ? 'Please enter your password'
      : 'Lütfen şifrenizi girin';
  String get authPasswordMinLength => localeName == 'en'
      ? 'Password must be at least 6 characters'
      : 'Şifre en az 6 karakter olmalıdır';
  String get authForgotPasswordInvalidEmail => authEmailInvalid;
  String get authForgotPasswordSent => localeName == 'en'
      ? 'A password reset link has been sent to your email.'
      : 'E-posta adresinize şifre sıfırlama bağlantısı gönderildi.';

  String get signUpNameHint =>
      localeName == 'en' ? 'Full name' : 'Adınız Soyadınız';
  String get signUpNameRequired => localeName == 'en'
      ? 'Please enter your name'
      : 'Lütfen adınızı girin';
  String get signUpNameMinLength => localeName == 'en'
      ? 'Name must be at least 2 characters'
      : 'İsim en az 2 karakter olmalıdır';
  String get signUpConfirmPasswordHint =>
      localeName == 'en' ? 'Repeat password' : 'Şifre Tekrar';
  String get signUpConfirmPasswordRequired => localeName == 'en'
      ? 'Please re-enter your password'
      : 'Lütfen şifrenizi tekrar girin';
  String get signUpConfirmPasswordMismatch => localeName == 'en'
      ? 'Passwords do not match'
      : 'Şifreler eşleşmiyor';

  String get notificationsTitle =>
      localeName == 'en' ? 'Notifications' : 'Bildirimler';
  String get notificationsEveningTitle => localeName == 'en'
      ? 'Evening motivation notification'
      : 'Akşam motivasyon bildirimi';
  String get notificationsEveningDescription => localeName == 'en'
      ? 'At your chosen time each day, a motivational quote for that day will be sent as a notification.'
      : 'Her gün seçtiğiniz saatte o günkü motivasyon cümlesi bildirim olarak gönderilir.';
  String get notificationsMorningTitle => localeName == 'en'
      ? 'Morning reminder'
      : 'Sabah hatırlatma';
  String get notificationsMorningDescription => localeName == 'en'
      ? 'At your chosen time each day, you\'ll get a reminder to open the app.'
      : 'Her gün seçtiğiniz saatte uygulamayı açmanız için hatırlatma gönderilir.';
  String get notificationsUnsupported => localeName == 'en'
      ? 'Notifications are not supported on this device (Android/iOS required).'
      : 'Bu cihazda bildirim desteklenmiyor (Android/iOS gerekli)';
  String get notificationsTimeLabel =>
      localeName == 'en' ? 'Time' : 'Saat';
  String get notificationsPickTimeTitle =>
      localeName == 'en' ? 'Choose time' : 'Saat seç';
  String get notificationsDone =>
      localeName == 'en' ? 'Done' : 'Tamam';

  // Map / history
  String get mapAreaLabel => localeName == 'en' ? 'Area' : 'Alan';
  String get mapPointsLabel => localeName == 'en' ? 'points' : 'nokta';
  String get mapCompletePolygonTitle =>
      localeName == 'en' ? 'Complete Polygon' : 'Poligonu Tamamla';
  String get mapCompletePolygonSubtitle => localeName == 'en'
      ? 'Give a name to the conquered area'
      : 'Fethedilen alan için bir isim verin';
  String get mapCompletedAreaLabel =>
      localeName == 'en' ? 'Conquered Area' : 'Fethedilen Alan';
  String get mapNameHint => localeName == 'en'
      ? 'E.g. Park Run, Seaside Walk...'
      : 'Örn: Park Turu, Sahil Yürüyüşü...';
  String get mapNameRequired => localeName == 'en'
      ? 'Please enter a name'
      : 'Lütfen bir isim girin';
  String get mapCancel =>
      localeName == 'en' ? 'Cancel' : 'İptal';
  String get mapConfirm =>
      localeName == 'en' ? 'Confirm' : 'Tamamla';
  String get mapSaved =>
      localeName == 'en' ? 'Polygon saved!' : 'Poligon kaydedildi!';
  String get mapGenericError =>
      localeName == 'en' ? 'An error occurred' : 'Bir hata oluştu';
  String get mapStop => localeName == 'en' ? 'STOP' : 'DURDUR';
  String get mapStart => localeName == 'en' ? 'START' : 'BAŞLA';
  String get mapTrackingCancelTitle =>
      localeName == 'en' ? 'Cancel tracking' : 'Takibi İptal Et';
  String get mapTrackingCancelQuestion =>
      localeName == 'en' ? 'Are you sure?' : 'Emin misiniz?';
  String get mapTrackingCancelWarning => localeName == 'en'
      ? 'If you cancel tracking, your current polygon will not be saved and all progress will be lost.'
      : 'Takibi iptal ederseniz, çizdiğiniz poligon kaydedilmeyecek ve tüm ilerleme silinecek.';
  String get mapNo =>
      localeName == 'en' ? 'No' : 'Hayır';
  String get mapYesCancel =>
      localeName == 'en' ? 'Yes, cancel' : 'Evet, İptal Et';
  String get mapCompletionSuggestion => localeName == 'en'
      ? 'You are close to the starting point! Do you want to complete the polygon?'
      : 'Başlangıç noktasına yaklaştınız! Poligonu tamamlamak ister misiniz?';
  String get mapCompletionAction =>
      localeName == 'en' ? 'Complete' : 'Tamamla';
  String get mapDeleteTitle =>
      localeName == 'en' ? 'Delete polygon' : 'Poligonu Sil';
  String get mapDeleteQuestion =>
      localeName == 'en' ? 'Are you sure?' : 'Emin misiniz?';
  String get mapDeleteWarning => localeName == 'en'
      ? 'This action cannot be undone. The polygon will be permanently deleted.'
      : 'Bu işlem geri alınamaz. Poligon kalıcı olarak silinecek.';
  String get mapDeleted =>
      localeName == 'en' ? 'Polygon deleted' : 'Poligon silindi';

  String get historyTitle =>
      localeName == 'en' ? 'History' : 'Geçmiş';
  String get historyRetry =>
      localeName == 'en' ? 'Try again' : 'Yeniden Dene';
  String get historyEmptyTitle =>
      localeName == 'en' ? 'No polygons yet' : 'Henüz poligon yok';
  String get historyEmptySubtitle => localeName == 'en'
      ? 'Start by drawing a polygon on the map'
      : 'Haritada poligon çizerek başlayın';
  String get historyGroupToday =>
      localeName == 'en' ? 'Today' : 'Bugün';
  String get historyGroupThisWeek =>
      localeName == 'en' ? 'This Week' : 'Bu Hafta';
  String get historyGroupThisMonth =>
      localeName == 'en' ? 'This Month' : 'Bu Ay';
  String get historyGroupThisYear =>
      localeName == 'en' ? 'This Year' : 'Bu Yıl';
  String get historyGroupOlder =>
      localeName == 'en' ? 'Older' : 'Daha Eski';
  String get historyShowOnMapTitle =>
      localeName == 'en' ? 'Show on Map' : 'Haritada Göster';
  String get historyShowOnMapQuestion => localeName == 'en'
      ? 'Do you want to see this polygon on the map?'
      : 'Bu poligonu haritada görmek ister misiniz?';
  String get historyAreaLabel =>
      localeName == 'en' ? 'Area' : 'Alan';
  String get historyPointsLabel =>
      localeName == 'en' ? 'Points' : 'Nokta';
  String get historyCancel =>
      localeName == 'en' ? 'Cancel' : 'İptal';
  String get historyGoToMap =>
      localeName == 'en' ? 'Go to Map' : 'Haritaya Git';
  String get historyDeleteTitle =>
      localeName == 'en' ? 'Delete polygon' : 'Poligonu Sil';
  String get historyDeleteQuestion =>
      localeName == 'en' ? 'Are you sure?' : 'Emin misiniz?';
  String get historyDeleted =>
      localeName == 'en' ? 'Polygon deleted' : 'Poligon silindi';
}

