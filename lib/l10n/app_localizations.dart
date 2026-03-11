import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'ZoneRun'**
  String get appTitle;

  /// No description provided for @languagePageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languagePageTitle;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsSavedNote.
  ///
  /// In tr, this message translates to:
  /// **'Seçiminiz kaydedildi. Uygulama dili değişti.'**
  String get settingsSavedNote;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get navMap;

  /// No description provided for @navHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get navHistory;

  /// No description provided for @guest.
  ///
  /// In tr, this message translates to:
  /// **'Misafir'**
  String get guest;

  /// No description provided for @sectionAchievements.
  ///
  /// In tr, this message translates to:
  /// **'Başarılar & Ödüller'**
  String get sectionAchievements;

  /// No description provided for @sectionMyAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabım'**
  String get sectionMyAccount;

  /// No description provided for @tasks.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get tasks;

  /// No description provided for @rewards.
  ///
  /// In tr, this message translates to:
  /// **'Ödüller'**
  String get rewards;

  /// No description provided for @privacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get deleteAccount;

  /// No description provided for @loginOrSignUp.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap / Kayıt Ol'**
  String get loginOrSignUp;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @editName.
  ///
  /// In tr, this message translates to:
  /// **'İsim Düzenle'**
  String get editName;

  /// No description provided for @editNameSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Görünen adınızı değiştirin'**
  String get editNameSubtitle;

  /// No description provided for @selectAvatar.
  ///
  /// In tr, this message translates to:
  /// **'Avatar Seç'**
  String get selectAvatar;

  /// No description provided for @selectAvatarSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hazır avatarlardan seçin'**
  String get selectAvatarSubtitle;

  /// No description provided for @weightOptional.
  ///
  /// In tr, this message translates to:
  /// **'Kilo (isteğe bağlı)'**
  String get weightOptional;

  /// No description provided for @weightSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kalori hesaplaması için kullanılır. Girmezsen 70 kg varsayılır.'**
  String get weightSubtitle;

  /// No description provided for @weightDialogHint.
  ///
  /// In tr, this message translates to:
  /// **'Kalori tahmini için kg girin. Boş bırakırsanız 70 kg varsayılarak hesaplanır.'**
  String get weightDialogHint;

  /// No description provided for @aboutTagline.
  ///
  /// In tr, this message translates to:
  /// **'Haritada koş, alan fethet'**
  String get aboutTagline;

  /// No description provided for @versionFormat.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm {version}'**
  String versionFormat(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In tr, this message translates to:
  /// **'ZoneRun ile yürüyerek veya koşarak haritada poligonlar çizebilir, mesafe ve alan takip edebilir, görevlerle ödüller açabilir ve istatistiklerinizi takip edebilirsiniz. Giriş isteğe bağlıdır; isterseniz misafir olarak da kullanabilirsiniz.'**
  String get aboutDescription;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik politikası'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım şartları'**
  String get termsOfUse;

  /// No description provided for @website.
  ///
  /// In tr, this message translates to:
  /// **'Web sitesi'**
  String get website;

  /// No description provided for @linkOpenFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı açılamadı'**
  String get linkOpenFailed;

  /// No description provided for @metricsConquered.
  ///
  /// In tr, this message translates to:
  /// **'FETHEDİLEN'**
  String get metricsConquered;

  /// No description provided for @metricsToday.
  ///
  /// In tr, this message translates to:
  /// **'BUGÜN'**
  String get metricsToday;

  /// No description provided for @metricsTotal.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM'**
  String get metricsTotal;

  /// No description provided for @metricsStatistics.
  ///
  /// In tr, this message translates to:
  /// **'İSTATİSTİKLER'**
  String get metricsStatistics;

  /// No description provided for @averageArea.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Alan'**
  String get averageArea;

  /// No description provided for @largestArea.
  ///
  /// In tr, this message translates to:
  /// **'En Büyük Alan'**
  String get largestArea;

  /// No description provided for @streak.
  ///
  /// In tr, this message translates to:
  /// **'Seri'**
  String get streak;

  /// No description provided for @highestStreak.
  ///
  /// In tr, this message translates to:
  /// **'En Yüksek Seri'**
  String get highestStreak;

  /// No description provided for @calories.
  ///
  /// In tr, this message translates to:
  /// **'Kalori'**
  String get calories;

  /// No description provided for @totalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get totalLabel;

  /// No description provided for @startButton.
  ///
  /// In tr, this message translates to:
  /// **'BAŞLA'**
  String get startButton;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızdan çıkış yapmak istediğinize emin misiniz?'**
  String get logoutConfirmMessage;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı sil'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız ve tüm verileriniz kalıcı olarak silinecek. Bu işlem geri alınamaz.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountConfirmConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı Sil'**
  String get deleteAccountConfirmConfirm;

  /// No description provided for @authLoginTab.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authLoginTab;

  /// No description provided for @authSignUpTab.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get authSignUpTab;

  /// No description provided for @authEmailHint.
  ///
  /// In tr, this message translates to:
  /// **'email@domain.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get authPasswordHint;

  /// No description provided for @authForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get authForgotPassword;

  /// No description provided for @authContinueButton.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get authContinueButton;

  /// No description provided for @authOr.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get authOr;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Devam Et'**
  String get authContinueWithGoogle;

  /// No description provided for @authTerms.
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursunuz'**
  String get authTerms;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordDescription.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.'**
  String get authForgotPasswordDescription;

  /// No description provided for @authEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen e-posta adresinizi girin'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen şifrenizi girin'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 6 karakter olmalıdır'**
  String get authPasswordMinLength;

  /// No description provided for @authForgotPasswordInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin'**
  String get authForgotPasswordInvalidEmail;

  /// No description provided for @authForgotPasswordSent.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresinize şifre sıfırlama bağlantısı gönderildi.'**
  String get authForgotPasswordSent;

  /// No description provided for @signUpNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Adınız Soyadınız'**
  String get signUpNameHint;

  /// No description provided for @signUpNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen adınızı girin'**
  String get signUpNameRequired;

  /// No description provided for @signUpNameMinLength.
  ///
  /// In tr, this message translates to:
  /// **'İsim en az 2 karakter olmalıdır'**
  String get signUpNameMinLength;

  /// No description provided for @signUpConfirmPasswordHint.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get signUpConfirmPasswordHint;

  /// No description provided for @signUpConfirmPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen şifrenizi tekrar girin'**
  String get signUpConfirmPasswordRequired;

  /// No description provided for @signUpConfirmPasswordMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor'**
  String get signUpConfirmPasswordMismatch;

  /// No description provided for @notificationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsTitle;

  /// No description provided for @notificationsEveningTitle.
  ///
  /// In tr, this message translates to:
  /// **'Akşam motivasyon bildirimi'**
  String get notificationsEveningTitle;

  /// No description provided for @notificationsEveningDescription.
  ///
  /// In tr, this message translates to:
  /// **'Her gün seçtiğiniz saatte o günkü motivasyon cümlesi bildirim olarak gönderilir.'**
  String get notificationsEveningDescription;

  /// No description provided for @notificationsMorningTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sabah hatırlatma'**
  String get notificationsMorningTitle;

  /// No description provided for @notificationsMorningDescription.
  ///
  /// In tr, this message translates to:
  /// **'Her gün seçtiğiniz saatte uygulamayı açmanız için hatırlatma gönderilir.'**
  String get notificationsMorningDescription;

  /// No description provided for @notificationsUnsupported.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda bildirim desteklenmiyor (Android/iOS gerekli)'**
  String get notificationsUnsupported;

  /// No description provided for @notificationsTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get notificationsTimeLabel;

  /// No description provided for @notificationsPickTimeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Saat seç'**
  String get notificationsPickTimeTitle;

  /// No description provided for @notificationsDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get notificationsDone;

  /// No description provided for @quickAccessHelp.
  ///
  /// In tr, this message translates to:
  /// **'Yardım'**
  String get quickAccessHelp;

  /// No description provided for @quickAccessStatistics.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get quickAccessStatistics;

  /// No description provided for @quickAccessThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu Tema'**
  String get quickAccessThemeDark;

  /// No description provided for @quickAccessThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık Tema'**
  String get quickAccessThemeLight;

  /// No description provided for @rewardsTabAvatars.
  ///
  /// In tr, this message translates to:
  /// **'Avatarlar'**
  String get rewardsTabAvatars;

  /// No description provided for @rewardsTabBanners.
  ///
  /// In tr, this message translates to:
  /// **'Bannerlar'**
  String get rewardsTabBanners;

  /// No description provided for @rewardsTabTitles.
  ///
  /// In tr, this message translates to:
  /// **'Sıfatlar'**
  String get rewardsTabTitles;

  /// No description provided for @rewardsTabAccessories.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuarlar'**
  String get rewardsTabAccessories;

  /// No description provided for @rewardsBannerSelectDescription.
  ///
  /// In tr, this message translates to:
  /// **'Banner arka planı seçin. Varsayılan ve kazandığınız bannerlar görünür.'**
  String get rewardsBannerSelectDescription;

  /// No description provided for @profileMembershipLabel.
  ///
  /// In tr, this message translates to:
  /// **'Üyelik'**
  String get profileMembershipLabel;

  /// No description provided for @helpPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yardım'**
  String get helpPageTitle;

  /// No description provided for @helpContactUs.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşın'**
  String get helpContactUs;

  /// No description provided for @helpContactDescription.
  ///
  /// In tr, this message translates to:
  /// **'Sorularınız veya önerileriniz için bize mail gönderebilirsiniz'**
  String get helpContactDescription;

  /// No description provided for @helpSubject.
  ///
  /// In tr, this message translates to:
  /// **'Konu'**
  String get helpSubject;

  /// No description provided for @helpSubjectHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Uygulama hatası, öneri...'**
  String get helpSubjectHint;

  /// No description provided for @helpSubjectRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir konu girin'**
  String get helpSubjectRequired;

  /// No description provided for @helpMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj'**
  String get helpMessage;

  /// No description provided for @helpMessageHint.
  ///
  /// In tr, this message translates to:
  /// **'Mesajınızı buraya yazın...'**
  String get helpMessageHint;

  /// No description provided for @helpMessageRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir mesaj girin'**
  String get helpMessageRequired;

  /// No description provided for @helpMessageMinLength.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj en az 10 karakter olmalıdır'**
  String get helpMessageMinLength;

  /// No description provided for @helpSendEmail.
  ///
  /// In tr, this message translates to:
  /// **'Mail Gönder'**
  String get helpSendEmail;

  /// No description provided for @helpMailOpened.
  ///
  /// In tr, this message translates to:
  /// **'Mail uygulamanız açıldı'**
  String get helpMailOpened;

  /// No description provided for @helpMailFailed.
  ///
  /// In tr, this message translates to:
  /// **'Mail gönderilemedi. Lütfen mail uygulamanızı kontrol edin.'**
  String get helpMailFailed;

  /// No description provided for @helpErrorOccurred.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu: {error}'**
  String helpErrorOccurred(String error);

  /// No description provided for @statsPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get statsPageTitle;

  /// No description provided for @statsLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Veriler yüklenemedi. Lütfen tekrar deneyin.'**
  String get statsLoadError;

  /// No description provided for @statsSectionPersonalRecords.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel rekorlar'**
  String get statsSectionPersonalRecords;

  /// No description provided for @statsSectionMonthComparison.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay / Geçen ay'**
  String get statsSectionMonthComparison;

  /// No description provided for @statsSectionActivityCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Aktivite takvimi'**
  String get statsSectionActivityCalendar;

  /// No description provided for @statsSectionWeeklySummary.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık özet'**
  String get statsSectionWeeklySummary;

  /// No description provided for @statsRecordLargestArea.
  ///
  /// In tr, this message translates to:
  /// **'En büyük alan (tek poligon)'**
  String get statsRecordLargestArea;

  /// No description provided for @statsRecordSingleDay.
  ///
  /// In tr, this message translates to:
  /// **'Tek günde en fazla'**
  String get statsRecordSingleDay;

  /// No description provided for @statsMilestones.
  ///
  /// In tr, this message translates to:
  /// **'Kilometre taşları'**
  String get statsMilestones;

  /// No description provided for @statsThisMonth.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay'**
  String get statsThisMonth;

  /// No description provided for @statsLastMonth.
  ///
  /// In tr, this message translates to:
  /// **'Geçen ay'**
  String get statsLastMonth;

  /// No description provided for @statsPolygonCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} poligon'**
  String statsPolygonCount(int count);

  /// No description provided for @statsMonthDiffMore.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay geçen aya göre {km} km fazla'**
  String statsMonthDiffMore(String km);

  /// No description provided for @statsMonthDiffLess.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay geçen aya göre {km} km az'**
  String statsMonthDiffLess(String km);

  /// No description provided for @statsTotalDistance.
  ///
  /// In tr, this message translates to:
  /// **'Toplam mesafe'**
  String get statsTotalDistance;

  /// No description provided for @statsTotalArea.
  ///
  /// In tr, this message translates to:
  /// **'Toplam alan'**
  String get statsTotalArea;

  /// No description provided for @statsPolygon.
  ///
  /// In tr, this message translates to:
  /// **'Poligon'**
  String get statsPolygon;

  /// No description provided for @statsCaloriesEstimate.
  ///
  /// In tr, this message translates to:
  /// **'Kalori (tahmini)'**
  String get statsCaloriesEstimate;

  /// No description provided for @statsStreakDays.
  ///
  /// In tr, this message translates to:
  /// **'Seri (gün)'**
  String get statsStreakDays;

  /// No description provided for @statsLongestStreak.
  ///
  /// In tr, this message translates to:
  /// **'En uzun seri'**
  String get statsLongestStreak;

  /// No description provided for @statsDays.
  ///
  /// In tr, this message translates to:
  /// **'{n} gün'**
  String statsDays(int n);

  /// No description provided for @statsHeatmapDescription.
  ///
  /// In tr, this message translates to:
  /// **'Sütunlar: Haftanın günleri (Pzt–Paz). Satırlar: Son 12 hafta (üst = 12 hf önce, alt = bu hafta).'**
  String get statsHeatmapDescription;

  /// No description provided for @statsHeatmapWeeksAgo.
  ///
  /// In tr, this message translates to:
  /// **'12 hf'**
  String get statsHeatmapWeeksAgo;

  /// No description provided for @statsHeatmapThisWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu hf'**
  String get statsHeatmapThisWeek;

  /// No description provided for @statsHeatmapNWeeks.
  ///
  /// In tr, this message translates to:
  /// **'{n} hf'**
  String statsHeatmapNWeeks(int n);

  /// No description provided for @statsHeatmapColorMeaning.
  ///
  /// In tr, this message translates to:
  /// **'Renk = günlük mesafe'**
  String get statsHeatmapColorMeaning;

  /// No description provided for @statsHeatmapLess.
  ///
  /// In tr, this message translates to:
  /// **'Az'**
  String get statsHeatmapLess;

  /// No description provided for @statsHeatmapMore.
  ///
  /// In tr, this message translates to:
  /// **'Çok'**
  String get statsHeatmapMore;

  /// No description provided for @statsHeatmapMon.
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get statsHeatmapMon;

  /// No description provided for @statsHeatmapTue.
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get statsHeatmapTue;

  /// No description provided for @statsHeatmapWed.
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get statsHeatmapWed;

  /// No description provided for @statsHeatmapThu.
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get statsHeatmapThu;

  /// No description provided for @statsHeatmapFri.
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get statsHeatmapFri;

  /// No description provided for @statsHeatmapSat.
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get statsHeatmapSat;

  /// No description provided for @statsHeatmapSun.
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get statsHeatmapSun;

  /// No description provided for @statsWeeklyNoData.
  ///
  /// In tr, this message translates to:
  /// **'Henüz haftalık veri yok'**
  String get statsWeeklyNoData;

  /// No description provided for @statsWeeklyDescription.
  ///
  /// In tr, this message translates to:
  /// **'Her çubuk = bir haftanın toplam mesafesi (km). Sol eksen: km. Bara tıklayınca o haftanın detayı görünür.'**
  String get statsWeeklyDescription;

  /// No description provided for @statsWeeklyTooltip.
  ///
  /// In tr, this message translates to:
  /// **'{km} km\n{count} poligon'**
  String statsWeeklyTooltip(String km, int count);

  /// No description provided for @statsWeeklyTapHint.
  ///
  /// In tr, this message translates to:
  /// **'Haftalara dokunun — detay için tıklayın'**
  String get statsWeeklyTapHint;

  /// No description provided for @tasksPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get tasksPageTitle;

  /// No description provided for @tasksSectionOneTime.
  ///
  /// In tr, this message translates to:
  /// **'Tek Seferlik Görevler'**
  String get tasksSectionOneTime;

  /// No description provided for @tasksSectionOneTimeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Avatar ve banner ödüllerini aç'**
  String get tasksSectionOneTimeSubtitle;

  /// No description provided for @tasksSectionRecurring.
  ///
  /// In tr, this message translates to:
  /// **'Günlük / Haftalık / Aylık'**
  String get tasksSectionRecurring;

  /// No description provided for @tasksSectionRecurringSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıfat ödüllerini kazan'**
  String get tasksSectionRecurringSubtitle;

  /// No description provided for @tasksRewardReady.
  ///
  /// In tr, this message translates to:
  /// **'Ödül hazır'**
  String get tasksRewardReady;

  /// No description provided for @tasksRewardPremiumAvatar.
  ///
  /// In tr, this message translates to:
  /// **'Premium Avatar'**
  String get tasksRewardPremiumAvatar;

  /// No description provided for @tasksRewardBannerId.
  ///
  /// In tr, this message translates to:
  /// **'Banner {id}'**
  String tasksRewardBannerId(String id);

  /// No description provided for @task_one_first_run_title.
  ///
  /// In tr, this message translates to:
  /// **'İlk Adım'**
  String get task_one_first_run_title;

  /// No description provided for @task_one_first_run_description.
  ///
  /// In tr, this message translates to:
  /// **'İlk koşunu tamamla'**
  String get task_one_first_run_description;

  /// No description provided for @task_one_1km_title.
  ///
  /// In tr, this message translates to:
  /// **'İlk Kilometre'**
  String get task_one_1km_title;

  /// No description provided for @task_one_1km_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 1 km koş'**
  String get task_one_1km_description;

  /// No description provided for @task_one_2streak_title.
  ///
  /// In tr, this message translates to:
  /// **'2 Gün Seri'**
  String get task_one_2streak_title;

  /// No description provided for @task_one_2streak_description.
  ///
  /// In tr, this message translates to:
  /// **'2 gün üst üste koş'**
  String get task_one_2streak_description;

  /// No description provided for @task_one_3runs_title.
  ///
  /// In tr, this message translates to:
  /// **'3 Koşu'**
  String get task_one_3runs_title;

  /// No description provided for @task_one_3runs_description.
  ///
  /// In tr, this message translates to:
  /// **'3 koşu tamamla'**
  String get task_one_3runs_description;

  /// No description provided for @task_one_3streak_title.
  ///
  /// In tr, this message translates to:
  /// **'3 Gün Seri'**
  String get task_one_3streak_title;

  /// No description provided for @task_one_3streak_description.
  ///
  /// In tr, this message translates to:
  /// **'3 gün üst üste koş'**
  String get task_one_3streak_description;

  /// No description provided for @task_one_10runs_title.
  ///
  /// In tr, this message translates to:
  /// **'10 Koşu'**
  String get task_one_10runs_title;

  /// No description provided for @task_one_10runs_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 10 koşu tamamla'**
  String get task_one_10runs_description;

  /// No description provided for @task_one_25km_title.
  ///
  /// In tr, this message translates to:
  /// **'25 km Ustası'**
  String get task_one_25km_title;

  /// No description provided for @task_one_25km_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 25 km koş'**
  String get task_one_25km_description;

  /// No description provided for @task_one_7streak_title.
  ///
  /// In tr, this message translates to:
  /// **'7 Gün Seri'**
  String get task_one_7streak_title;

  /// No description provided for @task_one_7streak_description.
  ///
  /// In tr, this message translates to:
  /// **'7 gün üst üste koş'**
  String get task_one_7streak_description;

  /// No description provided for @task_one_20runs_title.
  ///
  /// In tr, this message translates to:
  /// **'20 Koşu'**
  String get task_one_20runs_title;

  /// No description provided for @task_one_20runs_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 20 koşu tamamla'**
  String get task_one_20runs_description;

  /// No description provided for @task_one_30runs_title.
  ///
  /// In tr, this message translates to:
  /// **'30 Koşu'**
  String get task_one_30runs_title;

  /// No description provided for @task_one_30runs_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 30 koşu tamamla'**
  String get task_one_30runs_description;

  /// No description provided for @task_one_50km_avatar_title.
  ///
  /// In tr, this message translates to:
  /// **'50 km Koşucu'**
  String get task_one_50km_avatar_title;

  /// No description provided for @task_one_50km_avatar_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 50 km koş'**
  String get task_one_50km_avatar_description;

  /// No description provided for @task_one_10streak_title.
  ///
  /// In tr, this message translates to:
  /// **'10 Gün Seri'**
  String get task_one_10streak_title;

  /// No description provided for @task_one_10streak_description.
  ///
  /// In tr, this message translates to:
  /// **'10 gün üst üste koş'**
  String get task_one_10streak_description;

  /// No description provided for @task_one_50runs_title.
  ///
  /// In tr, this message translates to:
  /// **'50 Koşu'**
  String get task_one_50runs_title;

  /// No description provided for @task_one_50runs_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 50 koşu tamamla'**
  String get task_one_50runs_description;

  /// No description provided for @task_one_50km_banner_title.
  ///
  /// In tr, this message translates to:
  /// **'50 km'**
  String get task_one_50km_banner_title;

  /// No description provided for @task_one_50km_banner_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 50 km koş'**
  String get task_one_50km_banner_description;

  /// No description provided for @task_one_100km_banner_title.
  ///
  /// In tr, this message translates to:
  /// **'100 km'**
  String get task_one_100km_banner_title;

  /// No description provided for @task_one_100km_banner_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 100 km koş'**
  String get task_one_100km_banner_description;

  /// No description provided for @task_one_200km_banner_title.
  ///
  /// In tr, this message translates to:
  /// **'200 km'**
  String get task_one_200km_banner_title;

  /// No description provided for @task_one_200km_banner_description.
  ///
  /// In tr, this message translates to:
  /// **'Toplam 200 km koş'**
  String get task_one_200km_banner_description;

  /// No description provided for @task_one_streak_3_title_title.
  ///
  /// In tr, this message translates to:
  /// **'3 Gün Seri (Sıfat)'**
  String get task_one_streak_3_title_title;

  /// No description provided for @task_one_streak_3_title_description.
  ///
  /// In tr, this message translates to:
  /// **'3 gün üst üste koş'**
  String get task_one_streak_3_title_description;

  /// No description provided for @task_one_streak_5_title_title.
  ///
  /// In tr, this message translates to:
  /// **'5 Gün Seri (Sıfat)'**
  String get task_one_streak_5_title_title;

  /// No description provided for @task_one_streak_5_title_description.
  ///
  /// In tr, this message translates to:
  /// **'5 gün üst üste koş'**
  String get task_one_streak_5_title_description;

  /// No description provided for @task_daily_run_title.
  ///
  /// In tr, this message translates to:
  /// **'Günün Koşucusu'**
  String get task_daily_run_title;

  /// No description provided for @task_daily_run_description.
  ///
  /// In tr, this message translates to:
  /// **'Bugün en az 1 koşu tamamla'**
  String get task_daily_run_description;

  /// No description provided for @task_weekly_3_title.
  ///
  /// In tr, this message translates to:
  /// **'Haftanın Aktifi'**
  String get task_weekly_3_title;

  /// No description provided for @task_weekly_3_description.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta 3 koşu tamamla'**
  String get task_weekly_3_description;

  /// No description provided for @task_monthly_5_title.
  ///
  /// In tr, this message translates to:
  /// **'Ayın 5 Koşusu'**
  String get task_monthly_5_title;

  /// No description provided for @task_monthly_5_description.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay 5 koşu tamamla'**
  String get task_monthly_5_description;

  /// No description provided for @task_monthly_10_title.
  ///
  /// In tr, this message translates to:
  /// **'Ayın 10 Koşusu'**
  String get task_monthly_10_title;

  /// No description provided for @task_monthly_10_description.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay 10 koşu tamamla'**
  String get task_monthly_10_description;

  /// No description provided for @task_monthly_15_title.
  ///
  /// In tr, this message translates to:
  /// **'Ayın Fatihi'**
  String get task_monthly_15_title;

  /// No description provided for @task_monthly_15_description.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay 15 koşu tamamla'**
  String get task_monthly_15_description;

  /// No description provided for @targetKm.
  ///
  /// In tr, this message translates to:
  /// **'{value} km'**
  String targetKm(String value);

  /// No description provided for @targetM.
  ///
  /// In tr, this message translates to:
  /// **'{value} m'**
  String targetM(String value);

  /// No description provided for @targetRuns.
  ///
  /// In tr, this message translates to:
  /// **'{count} koşu'**
  String targetRuns(int count);

  /// No description provided for @targetStreakDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün seri'**
  String targetStreakDays(int count);

  /// No description provided for @targetTodayRuns.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {count} koşu'**
  String targetTodayRuns(int count);

  /// No description provided for @targetWeekRuns.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta {count} koşu'**
  String targetWeekRuns(int count);

  /// No description provided for @targetMonthRuns.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay {count} koşu'**
  String targetMonthRuns(int count);

  /// No description provided for @rewardTitleDailyRunner.
  ///
  /// In tr, this message translates to:
  /// **'Rüzgar'**
  String get rewardTitleDailyRunner;

  /// No description provided for @rewardTitleWeeklyActive.
  ///
  /// In tr, this message translates to:
  /// **'Momentum'**
  String get rewardTitleWeeklyActive;

  /// No description provided for @rewardTitleMonthlyChampion.
  ///
  /// In tr, this message translates to:
  /// **'Ayın Şampiyonu'**
  String get rewardTitleMonthlyChampion;

  /// No description provided for @rewardTitleWeekStreak3.
  ///
  /// In tr, this message translates to:
  /// **'Ateş Yakıldı'**
  String get rewardTitleWeekStreak3;

  /// No description provided for @rewardTitleWeekStreak5.
  ///
  /// In tr, this message translates to:
  /// **'Demir İrade'**
  String get rewardTitleWeekStreak5;

  /// No description provided for @rewardTitleMonthRuns5.
  ///
  /// In tr, this message translates to:
  /// **'Ayın Avcısı'**
  String get rewardTitleMonthRuns5;

  /// No description provided for @rewardTitleMonthRuns10.
  ///
  /// In tr, this message translates to:
  /// **'Tam Gaz'**
  String get rewardTitleMonthRuns10;

  /// No description provided for @overlayNone.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get overlayNone;

  /// No description provided for @overlayCrown.
  ///
  /// In tr, this message translates to:
  /// **'Taç'**
  String get overlayCrown;

  /// No description provided for @overlayStar.
  ///
  /// In tr, this message translates to:
  /// **'Yıldız'**
  String get overlayStar;

  /// No description provided for @overlayFire.
  ///
  /// In tr, this message translates to:
  /// **'Alev'**
  String get overlayFire;

  /// No description provided for @overlayCup.
  ///
  /// In tr, this message translates to:
  /// **'Kupa'**
  String get overlayCup;

  /// No description provided for @overlayBandage.
  ///
  /// In tr, this message translates to:
  /// **'Bandaj'**
  String get overlayBandage;

  /// No description provided for @overlayAccessoryId.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar {id}'**
  String overlayAccessoryId(String id);

  /// No description provided for @rewardsTitlesDescription.
  ///
  /// In tr, this message translates to:
  /// **'Banner\'da isminizin altında görünecek sıfatı seçin. Görevlerle yeni sıfatlar kazanın.'**
  String get rewardsTitlesDescription;

  /// No description provided for @rewardsNoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıfat yok'**
  String get rewardsNoTitle;

  /// No description provided for @rewardsToUnlock.
  ///
  /// In tr, this message translates to:
  /// **'Açmak için: {task} ({target})'**
  String rewardsToUnlock(String task, String target);

  /// No description provided for @profileEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil Düzenle'**
  String get profileEditTitle;

  /// No description provided for @profileEditSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İsim, avatar veya kiloyu güncelle'**
  String get profileEditSubtitle;

  /// No description provided for @profileLoginPrompt.
  ///
  /// In tr, this message translates to:
  /// **'İstatistiklerinizi koruyun ve yeni özelliklerden yararlanın. Giriş yapın veya kayıt olun.'**
  String get profileLoginPrompt;

  /// No description provided for @weightHintExample.
  ///
  /// In tr, this message translates to:
  /// **'Örn. 70'**
  String get weightHintExample;

  /// No description provided for @profileSelectAvatarDescription.
  ///
  /// In tr, this message translates to:
  /// **'Profilinizde görünecek avatarı seçin'**
  String get profileSelectAvatarDescription;

  /// No description provided for @profileTapAvatarToSelect.
  ///
  /// In tr, this message translates to:
  /// **'Seçmek için avatara dokunun'**
  String get profileTapAvatarToSelect;

  /// No description provided for @profileEnterNewName.
  ///
  /// In tr, this message translates to:
  /// **'Yeni isminizi girin'**
  String get profileEnterNewName;

  /// No description provided for @profileEnterNameHint.
  ///
  /// In tr, this message translates to:
  /// **'İsminizi girin'**
  String get profileEnterNameHint;

  /// No description provided for @profileAccountDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınız silindi.'**
  String get profileAccountDeleted;

  /// No description provided for @profileAccountDeleteError.
  ///
  /// In tr, this message translates to:
  /// **'Hesap silinirken hata oluştu.'**
  String get profileAccountDeleteError;

  /// No description provided for @rewardsPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödüller'**
  String get rewardsPageTitle;

  /// No description provided for @rewardsAccessoriesDescription.
  ///
  /// In tr, this message translates to:
  /// **'Avatar üzerinde gösterilecek aksesuarı seçin. Görevle açılanlar kullanılabilir.'**
  String get rewardsAccessoriesDescription;

  /// No description provided for @rewardsDefaultAvatars.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan avatarlar'**
  String get rewardsDefaultAvatars;

  /// No description provided for @rewardsPremiumAvatars.
  ///
  /// In tr, this message translates to:
  /// **'Premium avatarlar (görevle aç)'**
  String get rewardsPremiumAvatars;

  /// No description provided for @shareStatsLoadError.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler yüklenemedi.'**
  String get shareStatsLoadError;

  /// No description provided for @shareSelectBannerOrText.
  ///
  /// In tr, this message translates to:
  /// **'Banner görseli veya metin seçin.'**
  String get shareSelectBannerOrText;

  /// No description provided for @shareDefaultText.
  ///
  /// In tr, this message translates to:
  /// **'ZoneRun ile koşuyorum! 🏃'**
  String get shareDefaultText;

  /// No description provided for @shareTitle.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım'**
  String get shareTitle;

  /// No description provided for @shareOptions.
  ///
  /// In tr, this message translates to:
  /// **'Seçenekler'**
  String get shareOptions;

  /// No description provided for @shareOptionsDescription.
  ///
  /// In tr, this message translates to:
  /// **'Banner, metin ve istatistiklerden ne paylaşılacak?'**
  String get shareOptionsDescription;

  /// No description provided for @shareIncludeBanner.
  ///
  /// In tr, this message translates to:
  /// **'Banner görseli dahil'**
  String get shareIncludeBanner;

  /// No description provided for @shareIncludeText.
  ///
  /// In tr, this message translates to:
  /// **'Metin dahil (günlük motivasyon cümlesi)'**
  String get shareIncludeText;

  /// No description provided for @shareStatisticsOnBanner.
  ///
  /// In tr, this message translates to:
  /// **'Banner\'da gösterilecek istatistikler'**
  String get shareStatisticsOnBanner;

  /// No description provided for @shareStatTotalDistance.
  ///
  /// In tr, this message translates to:
  /// **'Toplam mesafe'**
  String get shareStatTotalDistance;

  /// No description provided for @shareStatPolygonCount.
  ///
  /// In tr, this message translates to:
  /// **'Poligon sayısı'**
  String get shareStatPolygonCount;

  /// No description provided for @shareStatTotalArea.
  ///
  /// In tr, this message translates to:
  /// **'Toplam alan'**
  String get shareStatTotalArea;

  /// No description provided for @shareStatStreak.
  ///
  /// In tr, this message translates to:
  /// **'Günlük seri'**
  String get shareStatStreak;

  /// No description provided for @shareStatLongestStreak.
  ///
  /// In tr, this message translates to:
  /// **'En uzun seri'**
  String get shareStatLongestStreak;

  /// No description provided for @shareStatMonthDistance.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay mesafe'**
  String get shareStatMonthDistance;

  /// No description provided for @shareStatMonthPolygon.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay poligon'**
  String get shareStatMonthPolygon;

  /// No description provided for @shareNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get shareNext;

  /// No description provided for @sharePreviewEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Banner görseli veya metin seçin; önizleme burada görünecek.'**
  String get sharePreviewEmpty;

  /// No description provided for @sharePreview.
  ///
  /// In tr, this message translates to:
  /// **'Önizleme'**
  String get sharePreview;

  /// No description provided for @shareButton.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get shareButton;

  /// No description provided for @sharePreparing.
  ///
  /// In tr, this message translates to:
  /// **'Hazırlanıyor...'**
  String get sharePreparing;

  /// No description provided for @shareLabelImage.
  ///
  /// In tr, this message translates to:
  /// **'Görsel'**
  String get shareLabelImage;

  /// No description provided for @shareLabelText.
  ///
  /// In tr, this message translates to:
  /// **'Metin'**
  String get shareLabelText;

  /// No description provided for @shareImageCreateError.
  ///
  /// In tr, this message translates to:
  /// **'Görsel oluşturulamadı.'**
  String get shareImageCreateError;

  /// No description provided for @shareShareOpenError.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım açılamadı.'**
  String get shareShareOpenError;

  /// No description provided for @mapStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get mapStart;

  /// No description provided for @mapPoint.
  ///
  /// In tr, this message translates to:
  /// **'Nokta'**
  String get mapPoint;

  /// No description provided for @mapArea.
  ///
  /// In tr, this message translates to:
  /// **'Alan'**
  String get mapArea;

  /// No description provided for @mapStop.
  ///
  /// In tr, this message translates to:
  /// **'DURDUR'**
  String get mapStop;

  /// No description provided for @mapCompletedAt.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı: {date}'**
  String mapCompletedAt(String date);

  /// No description provided for @mapDeleteConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Poligon kalıcı olarak silinecek.'**
  String get mapDeleteConfirmMessage;

  /// No description provided for @mapPolygonDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Poligon silindi'**
  String get mapPolygonDeleted;

  /// No description provided for @mapErrorOccurred.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get mapErrorOccurred;

  /// No description provided for @historyJustNow.
  ///
  /// In tr, this message translates to:
  /// **'Az önce'**
  String get historyJustNow;

  /// No description provided for @historyYesterday.
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get historyYesterday;

  /// No description provided for @historyToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get historyToday;

  /// No description provided for @historyThisWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get historyThisWeek;

  /// No description provided for @historyThisMonth.
  ///
  /// In tr, this message translates to:
  /// **'Bu Ay'**
  String get historyThisMonth;

  /// No description provided for @historyThisYear.
  ///
  /// In tr, this message translates to:
  /// **'Bu Yıl'**
  String get historyThisYear;

  /// No description provided for @historyOlder.
  ///
  /// In tr, this message translates to:
  /// **'Daha Eski'**
  String get historyOlder;

  /// No description provided for @historyShowOnMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada göster'**
  String get historyShowOnMap;

  /// No description provided for @historyRetry.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Dene'**
  String get historyRetry;

  /// No description provided for @historyNoPolygonsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz poligon yok'**
  String get historyNoPolygonsYet;

  /// No description provided for @historyEmptyHint.
  ///
  /// In tr, this message translates to:
  /// **'Haritada poligon çizerek başlayın'**
  String get historyEmptyHint;

  /// No description provided for @historyMinutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} dakika önce'**
  String historyMinutesAgo(int n);

  /// No description provided for @historyHoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} saat önce'**
  String historyHoursAgo(int n);

  /// No description provided for @historyDaysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} gün önce'**
  String historyDaysAgo(int n);

  /// No description provided for @historyWeeksAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} hafta önce'**
  String historyWeeksAgo(int n);

  /// No description provided for @historyMonthsAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} ay önce'**
  String historyMonthsAgo(int n);

  /// No description provided for @historyYearsAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n} yıl önce'**
  String historyYearsAgo(int n);

  /// No description provided for @bannerDefault.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan'**
  String get bannerDefault;

  /// No description provided for @bannerAurora.
  ///
  /// In tr, this message translates to:
  /// **'Aurora'**
  String get bannerAurora;

  /// No description provided for @bannerFire.
  ///
  /// In tr, this message translates to:
  /// **'Ateş'**
  String get bannerFire;

  /// No description provided for @bannerRise.
  ///
  /// In tr, this message translates to:
  /// **'Yükseliş'**
  String get bannerRise;

  /// No description provided for @notifChannelName.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Bildirimler'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In tr, this message translates to:
  /// **'Akşam motivasyon ve sabah hatırlatma'**
  String get notifChannelDescription;

  /// No description provided for @notifMorningBody.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın! Bugünkü hedefin için hazır mısın?'**
  String get notifMorningBody;

  /// No description provided for @authErrorAuthStateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Oturum durumu kontrol edilemedi. Lütfen tekrar deneyin.'**
  String get authErrorAuthStateFailed;

  /// No description provided for @authErrorNotReady.
  ///
  /// In tr, this message translates to:
  /// **'Giriş sistemi hazır değil. Lütfen uygulamayı yeniden başlatın.'**
  String get authErrorNotReady;

  /// No description provided for @authErrorSignUpFailed.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt olurken beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get authErrorSignUpFailed;

  /// No description provided for @authErrorSignInFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılırken beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.'**
  String get authErrorSignInFailed;

  /// No description provided for @authErrorGoogleCancelled.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş iptal edildi.'**
  String get authErrorGoogleCancelled;

  /// No description provided for @authErrorGoogleFailed.
  ///
  /// In tr, this message translates to:
  /// **'Google ile giriş yapılırken bir hata oluştu. Lütfen tekrar deneyin.'**
  String get authErrorGoogleFailed;

  /// No description provided for @authErrorPasswordResetFailed.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama e-postası gönderilemedi. Lütfen tekrar deneyin.'**
  String get authErrorPasswordResetFailed;

  /// No description provided for @authErrorSignOutFailed.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapılırken bir hata oluştu. Lütfen tekrar deneyin.'**
  String get authErrorSignOutFailed;

  /// No description provided for @authErrorSignInRequired.
  ///
  /// In tr, this message translates to:
  /// **'Hesap silmek için önce giriş yapmalısınız.'**
  String get authErrorSignInRequired;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre çok zayıf. En az 6 karakter ve mümkünse harf, rakam kullanın.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresi zaten kayıtlı. Giriş yapın veya farklı bir e-posta deneyin.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin (örn. ad@alan.com).'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Bu hesap devre dışı bırakılmış. Destek ile iletişime geçin.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı hesap bulunamadı. Kayıt olmayı deneyin.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış şifre. Şifrenizi kontrol edip tekrar deneyin.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorInvalidCredential.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı. Bilgilerinizi kontrol edin.'**
  String get authErrorInvalidCredential;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme. Lütfen bir süre bekleyip tekrar deneyin.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorOperationNotAllowed.
  ///
  /// In tr, this message translates to:
  /// **'Bu giriş yöntemi şu an kapalı. E-posta ile giriş yapmayı deneyin.'**
  String get authErrorOperationNotAllowed;

  /// No description provided for @authErrorRequiresRecentLogin.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik için önce çıkış yapıp tekrar giriş yapın, ardından hesabı sil\'i tekrar deneyin.'**
  String get authErrorRequiresRecentLogin;

  /// No description provided for @authErrorNetworkFailed.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantınızı kontrol edin ve tekrar deneyin.'**
  String get authErrorNetworkFailed;

  /// No description provided for @authErrorExpiredActionCode.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısının süresi dolmuş. Lütfen yenisi isteyin.'**
  String get authErrorExpiredActionCode;

  /// No description provided for @authErrorInvalidActionCode.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısı geçersiz veya zaten kullanılmış.'**
  String get authErrorInvalidActionCode;

  /// No description provided for @authErrorPopupClosed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş penceresi kapatıldı. Tekrar denemek ister misiniz?'**
  String get authErrorPopupClosed;

  /// No description provided for @authErrorPopupBlocked.
  ///
  /// In tr, this message translates to:
  /// **'Giriş penceresi engellendi. Tarayıcıda açılır pencerelere izin verin.'**
  String get authErrorPopupBlocked;

  /// No description provided for @authErrorAccountExistsDifferentCredential.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta başka bir giriş yöntemiyle kayıtlı. O yöntemi kullanın.'**
  String get authErrorAccountExistsDifferentCredential;

  /// No description provided for @authErrorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu. Lütfen tekrar deneyin.'**
  String get authErrorGeneric;

  /// No description provided for @firebaseErrorNotReady.
  ///
  /// In tr, this message translates to:
  /// **'Veritabanı hazır değil. Uygulama başlatılamadı.'**
  String get firebaseErrorNotReady;

  /// No description provided for @firebaseErrorAuthNotReady.
  ///
  /// In tr, this message translates to:
  /// **'Giriş sistemi hazır değil. Uygulama başlatılamadı.'**
  String get firebaseErrorAuthNotReady;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
