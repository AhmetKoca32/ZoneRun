// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZoneRun';

  @override
  String get languagePageTitle => 'Language';

  @override
  String get language => 'Language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsSavedNote =>
      'Your choice has been saved. App language has been updated.';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navHistory => 'History';

  @override
  String get guest => 'Guest';

  @override
  String get sectionAchievements => 'Achievements & Rewards';

  @override
  String get sectionMyAccount => 'My Account';

  @override
  String get tasks => 'Tasks';

  @override
  String get rewards => 'Rewards';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'About';

  @override
  String get logout => 'Log out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get loginOrSignUp => 'Log in / Sign up';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editName => 'Edit name';

  @override
  String get editNameSubtitle => 'Change your display name';

  @override
  String get selectAvatar => 'Select avatar';

  @override
  String get selectAvatarSubtitle => 'Choose from ready-made avatars';

  @override
  String get weightOptional => 'Weight (optional)';

  @override
  String get weightSubtitle =>
      'Used for calorie calculation. If empty, 70 kg is assumed.';

  @override
  String get weightDialogHint =>
      'Enter kg for calorie estimate. If left blank, calories are estimated assuming 70 kg.';

  @override
  String get aboutTagline => 'Run on the map, conquer area';

  @override
  String versionFormat(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'With ZoneRun you can draw polygons on the map by walking or running, track distance and area, unlock rewards with tasks and follow your statistics. Sign-in is optional; you can also use the app as a guest.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get website => 'Website';

  @override
  String get linkOpenFailed => 'Could not open link';

  @override
  String get metricsConquered => 'CONQUERED';

  @override
  String get metricsToday => 'TODAY';

  @override
  String get metricsTotal => 'TOTAL';

  @override
  String get metricsStatistics => 'STATISTICS';

  @override
  String get averageArea => 'Average area';

  @override
  String get largestArea => 'Largest area';

  @override
  String get streak => 'Streak';

  @override
  String get highestStreak => 'Highest streak';

  @override
  String get calories => 'Calories';

  @override
  String get totalLabel => 'Total';

  @override
  String get startButton => 'START';

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to log out of your account?';

  @override
  String get deleteAccountConfirmTitle => 'Delete account';

  @override
  String get deleteAccountConfirmMessage =>
      'Your account and all data will be permanently deleted. This action cannot be undone.';

  @override
  String get deleteAccountConfirmConfirm => 'Delete account';

  @override
  String get authLoginTab => 'Log in';

  @override
  String get authSignUpTab => 'Sign up';

  @override
  String get authEmailHint => 'email@domain.com';

  @override
  String get authPasswordHint => 'Password';

  @override
  String get authForgotPassword => 'Forgot password';

  @override
  String get authContinueButton => 'Continue';

  @override
  String get authOr => 'or';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authTerms =>
      'By continuing, you agree to the Terms of Use and Privacy Policy.';

  @override
  String get authTermsPrefix => 'By continuing, you agree to the ';

  @override
  String get authTermsAnd => ' and ';

  @override
  String get authTermsSuffix => '.';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authForgotPasswordDescription =>
      'Enter your email address and we\'ll send you a reset link.';

  @override
  String get authEmailRequired => 'Please enter your email address';

  @override
  String get authEmailInvalid => 'Please enter a valid email address';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authForgotPasswordInvalidEmail =>
      'Please enter a valid email address';

  @override
  String get authForgotPasswordSend => 'Send';

  @override
  String get authForgotPasswordSent =>
      'A password reset link has been sent to your email.';

  @override
  String get signUpNameHint => 'Full name';

  @override
  String get signUpNameRequired => 'Please enter your name';

  @override
  String get signUpNameMinLength => 'Name must be at least 2 characters';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get signUpConfirmPasswordHint => 'Repeat password';

  @override
  String get signUpConfirmPasswordRequired => 'Please re-enter your password';

  @override
  String get signUpConfirmPasswordMismatch => 'Passwords do not match';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEveningTitle => 'Evening motivation notification';

  @override
  String get notificationsEveningDescription =>
      'At your chosen time each day, a motivational quote for that day will be sent as a notification.';

  @override
  String get notificationsMorningTitle => 'Morning reminder';

  @override
  String get notificationsMorningDescription =>
      'At your chosen time each day, you\'ll get a reminder to open the app.';

  @override
  String get notificationsUnsupported =>
      'Notifications are not supported on this device (Android/iOS required).';

  @override
  String get notificationsTimeLabel => 'Time';

  @override
  String get notificationsPickTimeTitle => 'Choose time';

  @override
  String get notificationsDone => 'Done';

  @override
  String get quickAccessHelp => 'Help';

  @override
  String get quickAccessStatistics => 'Statistics';

  @override
  String get quickAccessThemeDark => 'Dark theme';

  @override
  String get quickAccessThemeLight => 'Light theme';

  @override
  String get rewardsTabAvatars => 'Avatars';

  @override
  String get rewardsTabBanners => 'Banners';

  @override
  String get rewardsTabTitles => 'Titles';

  @override
  String get rewardsTabAccessories => 'Accessories';

  @override
  String get rewardsBannerSelectDescription =>
      'Select banner background. Default and unlocked banners are shown.';

  @override
  String get profileMembershipLabel => 'Member since';

  @override
  String get helpPageTitle => 'Help';

  @override
  String get helpContactUs => 'Contact Us';

  @override
  String get helpContactDescription =>
      'Send us an email for your questions or suggestions.';

  @override
  String get helpSubject => 'Subject';

  @override
  String get helpSubjectHint => 'E.g.: App bug, suggestion...';

  @override
  String get helpSubjectRequired => 'Please enter a subject';

  @override
  String get helpMessage => 'Message';

  @override
  String get helpMessageHint => 'Write your message here...';

  @override
  String get helpMessageRequired => 'Please enter a message';

  @override
  String get helpMessageMinLength => 'Message must be at least 10 characters';

  @override
  String get helpSendEmail => 'Send Email';

  @override
  String get helpMailOpened => 'Your mail app has been opened';

  @override
  String get helpMailFailed =>
      'Could not send email. Please check your mail app.';

  @override
  String helpErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get statsPageTitle => 'Statistics';

  @override
  String get statsLoadError => 'Could not load data. Please try again.';

  @override
  String get statsSectionPersonalRecords => 'Personal records';

  @override
  String get statsSectionMonthComparison => 'This month / Last month';

  @override
  String get statsSectionActivityCalendar => 'Activity calendar';

  @override
  String get statsSectionWeeklySummary => 'Weekly summary';

  @override
  String get statsRecordLargestArea => 'Largest area (single polygon)';

  @override
  String get statsRecordSingleDay => 'Most in one day';

  @override
  String get statsMilestones => 'Milestones';

  @override
  String get statsThisMonth => 'This month';

  @override
  String get statsLastMonth => 'Last month';

  @override
  String statsPolygonCount(int count) {
    return '$count polygons';
  }

  @override
  String statsMonthDiffMore(String km) {
    return 'This month $km km more than last month';
  }

  @override
  String statsMonthDiffLess(String km) {
    return 'This month $km km less than last month';
  }

  @override
  String get statsTotalDistance => 'Total distance';

  @override
  String get statsTotalArea => 'Total area';

  @override
  String get statsPolygon => 'Polygons';

  @override
  String get statsCaloriesEstimate => 'Calories (estimate)';

  @override
  String get statsStreakDays => 'Streak (days)';

  @override
  String get statsLongestStreak => 'Longest streak';

  @override
  String statsDays(int n) {
    return '$n days';
  }

  @override
  String get statsHeatmapDescription =>
      'Columns: weekdays (Mon–Sun). Rows: last 12 weeks (top = 12 w ago, bottom = this week).';

  @override
  String get statsHeatmapWeeksAgo => '12 w';

  @override
  String get statsHeatmapThisWeek => 'This wk';

  @override
  String statsHeatmapNWeeks(int n) {
    return '$n w';
  }

  @override
  String get statsHeatmapColorMeaning => 'Color = daily distance';

  @override
  String get statsHeatmapLess => 'Less';

  @override
  String get statsHeatmapMore => 'More';

  @override
  String get statsHeatmapMon => 'Mon';

  @override
  String get statsHeatmapTue => 'Tue';

  @override
  String get statsHeatmapWed => 'Wed';

  @override
  String get statsHeatmapThu => 'Thu';

  @override
  String get statsHeatmapFri => 'Fri';

  @override
  String get statsHeatmapSat => 'Sat';

  @override
  String get statsHeatmapSun => 'Sun';

  @override
  String get statsWeeklyNoData => 'No weekly data yet';

  @override
  String get statsWeeklyDescription =>
      'Each bar = one week\'s total distance (km). Left axis: km. Tap a bar to see that week\'s details.';

  @override
  String statsWeeklyTooltip(String km, int count) {
    return '$km km\n$count polygons';
  }

  @override
  String get statsWeeklyTapHint => 'Tap weeks for details';

  @override
  String get tasksPageTitle => 'Tasks';

  @override
  String get tasksSectionOneTime => 'One-time tasks';

  @override
  String get tasksSectionOneTimeSubtitle => 'Unlock avatar and banner rewards';

  @override
  String get tasksSectionRecurring => 'Daily / Weekly / Monthly';

  @override
  String get tasksSectionRecurringSubtitle => 'Earn title rewards';

  @override
  String get tasksRewardReady => 'Reward ready';

  @override
  String get tasksRewardPremiumAvatar => 'Premium Avatar';

  @override
  String tasksRewardBannerId(String id) {
    return 'Banner $id';
  }

  @override
  String get task_one_first_run_title => 'First Step';

  @override
  String get task_one_first_run_description => 'Complete your first run';

  @override
  String get task_one_1km_title => 'First Kilometer';

  @override
  String get task_one_1km_description => 'Run 1 km total';

  @override
  String get task_one_2streak_title => '2 Day Streak';

  @override
  String get task_one_2streak_description => 'Run 2 days in a row';

  @override
  String get task_one_3runs_title => '3 Runs';

  @override
  String get task_one_3runs_description => 'Complete 3 runs';

  @override
  String get task_one_3streak_title => '3 Day Streak';

  @override
  String get task_one_3streak_description => 'Run 3 days in a row';

  @override
  String get task_one_10runs_title => '10 Runs';

  @override
  String get task_one_10runs_description => 'Complete 10 runs total';

  @override
  String get task_one_25km_title => '25 km Master';

  @override
  String get task_one_25km_description => 'Run 25 km total';

  @override
  String get task_one_7streak_title => '7 Day Streak';

  @override
  String get task_one_7streak_description => 'Run 7 days in a row';

  @override
  String get task_one_20runs_title => '20 Runs';

  @override
  String get task_one_20runs_description => 'Complete 20 runs total';

  @override
  String get task_one_30runs_title => '30 Runs';

  @override
  String get task_one_30runs_description => 'Complete 30 runs total';

  @override
  String get task_one_50km_avatar_title => '50 km Runner';

  @override
  String get task_one_50km_avatar_description => 'Run 50 km total';

  @override
  String get task_one_10streak_title => '10 Day Streak';

  @override
  String get task_one_10streak_description => 'Run 10 days in a row';

  @override
  String get task_one_50runs_title => '50 Runs';

  @override
  String get task_one_50runs_description => 'Complete 50 runs total';

  @override
  String get task_one_50km_banner_title => '50 km';

  @override
  String get task_one_50km_banner_description => 'Run 50 km total';

  @override
  String get task_one_100km_banner_title => '100 km';

  @override
  String get task_one_100km_banner_description => 'Run 100 km total';

  @override
  String get task_one_200km_banner_title => '200 km';

  @override
  String get task_one_200km_banner_description => 'Run 200 km total';

  @override
  String get task_one_streak_3_title_title => '3 Day Streak (Title)';

  @override
  String get task_one_streak_3_title_description => 'Run 3 days in a row';

  @override
  String get task_one_streak_5_title_title => '5 Day Streak (Title)';

  @override
  String get task_one_streak_5_title_description => 'Run 5 days in a row';

  @override
  String get task_daily_run_title => 'Daily Runner';

  @override
  String get task_daily_run_description => 'Complete at least 1 run today';

  @override
  String get task_weekly_3_title => 'Weekly Active';

  @override
  String get task_weekly_3_description => 'Complete 3 runs this week';

  @override
  String get task_monthly_5_title => '5 Runs of the Month';

  @override
  String get task_monthly_5_description => 'Complete 5 runs this month';

  @override
  String get task_monthly_10_title => '10 Runs of the Month';

  @override
  String get task_monthly_10_description => 'Complete 10 runs this month';

  @override
  String get task_monthly_15_title => 'Monthly Champion';

  @override
  String get task_monthly_15_description => 'Complete 15 runs this month';

  @override
  String targetKm(String value) {
    return '$value km';
  }

  @override
  String targetM(String value) {
    return '$value m';
  }

  @override
  String targetRuns(int count) {
    return '$count runs';
  }

  @override
  String targetStreakDays(int count) {
    return '$count day streak';
  }

  @override
  String targetTodayRuns(int count) {
    return 'Today $count runs';
  }

  @override
  String targetWeekRuns(int count) {
    return 'This week $count runs';
  }

  @override
  String targetMonthRuns(int count) {
    return 'This month $count runs';
  }

  @override
  String get rewardTitleDailyRunner => 'Wind';

  @override
  String get rewardTitleWeeklyActive => 'Momentum';

  @override
  String get rewardTitleMonthlyChampion => 'Monthly Champion';

  @override
  String get rewardTitleWeekStreak3 => 'Fire Lit';

  @override
  String get rewardTitleWeekStreak5 => 'Iron Will';

  @override
  String get rewardTitleMonthRuns5 => 'Hunter of the Month';

  @override
  String get rewardTitleMonthRuns10 => 'Full Throttle';

  @override
  String get overlayNone => 'None';

  @override
  String get overlayCrown => 'Crown';

  @override
  String get overlayStar => 'Star';

  @override
  String get overlayFire => 'Flame';

  @override
  String get overlayCup => 'Trophy';

  @override
  String get overlayBandage => 'Bandage';

  @override
  String overlayAccessoryId(String id) {
    return 'Accessory $id';
  }

  @override
  String get rewardsTitlesDescription =>
      'Choose the title that appears below your name on the banner. Earn new titles with tasks.';

  @override
  String get rewardsNoTitle => 'No title';

  @override
  String rewardsToUnlock(String task, String target) {
    return 'To unlock: $task ($target)';
  }

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditSubtitle => 'Update name, avatar or weight';

  @override
  String get profileLoginPrompt =>
      'Keep your stats and get more features. Log in or sign up.';

  @override
  String get weightHintExample => 'E.g. 70';

  @override
  String get profileSelectAvatarDescription =>
      'Choose the avatar that will appear on your profile.';

  @override
  String get profileTapAvatarToSelect => 'Tap an avatar to select it.';

  @override
  String get profileEnterNewName => 'Enter your new name';

  @override
  String get profileEnterNameHint => 'Enter your name';

  @override
  String get profileEmailNotVerified =>
      'Your email is not verified. Please check your inbox.';

  @override
  String get profileEmailResend => 'Resend';

  @override
  String get profileEmailResendSuccess => 'Verification email has been resent.';

  @override
  String get profileEmailResendError =>
      'Could not send email. Please try again later.';

  @override
  String get profileEmailVerified => 'Email verified!';

  @override
  String get profileAccountDeleted => 'Your account has been deleted.';

  @override
  String get profileAccountDeleteError =>
      'An error occurred while deleting your account.';

  @override
  String get rewardsPageTitle => 'Rewards';

  @override
  String get rewardsAccessoriesDescription =>
      'Choose accessories to show on your avatar. Unlock them with tasks.';

  @override
  String get rewardsDefaultAvatars => 'Default avatars';

  @override
  String get rewardsPremiumAvatars => 'Premium avatars (unlock with tasks)';

  @override
  String get shareStatsLoadError => 'Could not load statistics.';

  @override
  String get shareSelectBannerOrText => 'Select banner image or text.';

  @override
  String get shareDefaultText => 'Running with ZoneRun! 🏃';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareOptions => 'Options';

  @override
  String get shareOptionsDescription =>
      'What to include: banner, text and statistics?';

  @override
  String get shareIncludeBanner => 'Include banner image';

  @override
  String get shareIncludeText => 'Include text (daily motivation quote)';

  @override
  String get shareStatisticsOnBanner => 'Statistics to show on banner';

  @override
  String get shareStatTotalDistance => 'Total distance';

  @override
  String get shareStatPolygonCount => 'Polygon count';

  @override
  String get shareStatTotalArea => 'Total area';

  @override
  String get shareStatStreak => 'Daily streak';

  @override
  String get shareStatLongestStreak => 'Longest streak';

  @override
  String get shareStatMonthDistance => 'This month distance';

  @override
  String get shareStatMonthPolygon => 'This month polygons';

  @override
  String get shareNext => 'Next';

  @override
  String get sharePreviewEmpty =>
      'Select banner image or text; preview will appear here.';

  @override
  String get sharePreview => 'Preview';

  @override
  String get shareButton => 'Share';

  @override
  String get sharePreparing => 'Preparing...';

  @override
  String get shareLabelImage => 'Image';

  @override
  String get shareLabelText => 'Text';

  @override
  String get shareImageCreateError => 'Could not create image.';

  @override
  String get shareShareOpenError => 'Could not open share.';

  @override
  String get mapStart => 'Start';

  @override
  String get mapPoint => 'Point';

  @override
  String get mapArea => 'Area';

  @override
  String get mapStop => 'STOP';

  @override
  String mapCompletedAt(String date) {
    return 'Completed: $date';
  }

  @override
  String get mapDeleteConfirmMessage =>
      'This action cannot be undone. The polygon will be permanently deleted.';

  @override
  String get mapPolygonDeleted => 'Polygon deleted';

  @override
  String get mapErrorOccurred => 'An error occurred';

  @override
  String get historyJustNow => 'Just now';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyToday => 'Today';

  @override
  String get historyThisWeek => 'This week';

  @override
  String get historyThisMonth => 'This month';

  @override
  String get historyThisYear => 'This year';

  @override
  String get historyOlder => 'Older';

  @override
  String get historyShowOnMap => 'Show on map';

  @override
  String get historyRetry => 'Retry';

  @override
  String get historyNoPolygonsYet => 'No polygons yet';

  @override
  String get historyEmptyHint => 'Start by drawing a polygon on the map';

  @override
  String historyMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String historyHoursAgo(int n) {
    return '$n hours ago';
  }

  @override
  String historyDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String historyWeeksAgo(int n) {
    return '$n weeks ago';
  }

  @override
  String historyMonthsAgo(int n) {
    return '$n months ago';
  }

  @override
  String historyYearsAgo(int n) {
    return '$n years ago';
  }

  @override
  String get bannerDefault => 'Default';

  @override
  String get bannerAurora => 'Aurora';

  @override
  String get bannerFire => 'Fire';

  @override
  String get bannerRise => 'Rise';

  @override
  String get notifChannelName => 'Daily notifications';

  @override
  String get notifChannelDescription =>
      'Evening motivation and morning reminder';

  @override
  String get notifMorningBody => 'Good morning! Ready for today\'s goal?';

  @override
  String get authErrorAuthStateFailed =>
      'Could not check sign-in state. Please try again.';

  @override
  String get authErrorNotReady =>
      'Sign-in is not ready. Please restart the app.';

  @override
  String get authErrorSignUpFailed =>
      'An unexpected error occurred while signing up. Please try again.';

  @override
  String get authErrorSignInFailed =>
      'An error occurred while signing in. Please try again.';

  @override
  String get authErrorGoogleCancelled => 'Sign-in with Google was cancelled.';

  @override
  String get authErrorGoogleFailed =>
      'An error occurred with Google sign-in. Please try again.';

  @override
  String get authErrorPasswordResetFailed =>
      'Could not send password reset email. Please try again.';

  @override
  String get authErrorSignOutFailed =>
      'An error occurred while signing out. Please try again.';

  @override
  String get authErrorSignInRequired =>
      'You must sign in first to delete your account.';

  @override
  String get authErrorWeakPassword =>
      'Password is too weak. Use at least 6 characters and preferably letters and numbers.';

  @override
  String get authErrorEmailInUse =>
      'This email is already registered. Sign in or try a different email.';

  @override
  String get authErrorInvalidEmail =>
      'Please enter a valid email address (e.g. name@domain.com).';

  @override
  String get authErrorUserDisabled =>
      'This account has been disabled. Contact support.';

  @override
  String get authErrorUserNotFound =>
      'No account found with this email. Try signing up.';

  @override
  String get authErrorWrongPassword => 'Wrong password. Check and try again.';

  @override
  String get authErrorInvalidCredential =>
      'Email or password incorrect. Check your details.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please wait and try again.';

  @override
  String get authErrorOperationNotAllowed =>
      'This sign-in method is currently disabled. Try email sign-in.';

  @override
  String get authErrorRequiresRecentLogin =>
      'For security, sign out and sign in again, then try deleting your account.';

  @override
  String get authErrorNetworkFailed =>
      'Check your internet connection and try again.';

  @override
  String get authErrorExpiredActionCode =>
      'Password reset link has expired. Please request a new one.';

  @override
  String get authErrorInvalidActionCode =>
      'Password reset link is invalid or already used.';

  @override
  String get authErrorPopupClosed =>
      'Sign-in window was closed. Would you like to try again?';

  @override
  String get authErrorPopupBlocked =>
      'Sign-in window was blocked. Allow popups in your browser.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'This email is registered with another sign-in method. Use that method.';

  @override
  String get authErrorGeneric => 'An error occurred. Please try again.';

  @override
  String get firebaseErrorNotReady =>
      'Database is not ready. App could not start.';

  @override
  String get firebaseErrorAuthNotReady =>
      'Sign-in is not ready. App could not start.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingWelcomeTitle => 'Welcome to ZoneRun';

  @override
  String get onboardingWelcomeDescription =>
      'Explore zones, track your stats and earn rewards.';

  @override
  String get onboardingMapTitle => 'Draw Zones on the Map';

  @override
  String get onboardingMapDescription =>
      'Track your walk with GPS and create your own zone on the map.';

  @override
  String get onboardingTasksTitle => 'Tasks and Rewards';

  @override
  String get onboardingTasksDescription =>
      'Complete tasks, earn titles and banners.';

  @override
  String get onboardingStatsTitle => 'Track Your Stats';

  @override
  String get onboardingStatsDescription =>
      'View distance, area and calorie statistics.';

  @override
  String get coachGotIt => 'Got it';

  @override
  String get coachNext => 'Next';

  @override
  String get coachProfileIcon => 'View your profile and settings here.';

  @override
  String get coachNotificationIcon => 'Check your notifications here.';

  @override
  String get coachConqueredArea => 'Your total conquered area is shown here.';

  @override
  String get coachTodayDistance => 'Today\'s distance is shown here.';

  @override
  String get coachTotalDistance => 'Your total distance is shown here.';

  @override
  String get coachStatistics => 'Tap here to see your detailed statistics.';

  @override
  String get coachStartButton => 'Tap here to start tracking a new zone.';

  @override
  String get coachMapStart => 'Press this button to start GPS tracking.';

  @override
  String get coachMapComplete => 'Use this button to save your zone.';

  @override
  String get coachMapCancel => 'Use this button to cancel tracking.';

  @override
  String get coachProfileBanner =>
      'Tap your profile to edit your name, avatar and weight.';

  @override
  String get coachProfileShare => 'Share your profile on social media.';

  @override
  String get coachProfileQuickAccess =>
      'Access help center, statistics or change your theme from here.';

  @override
  String get coachProfileTasks => 'Complete tasks to earn rewards!';

  @override
  String get coachProfileRewards =>
      'Choose your unlocked avatars, banners and titles here.';
}
