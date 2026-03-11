import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/home/data/services/motivation_quote_service.dart';

/// Locale-based strings for notification channel and morning body (no BuildContext).
class _NotificationL10n {
  static String channelName(String locale) {
    switch (locale) {
      case 'en':
        return 'Daily notifications';
      case 'tr':
        return 'Günlük Bildirimler';
      default:
        return 'Daily notifications';
    }
  }

  static String channelDescription(String locale) {
    switch (locale) {
      case 'en':
        return 'Evening motivation and morning reminder';
      case 'tr':
        return 'Akşam motivasyon ve sabah hatırlatma';
      default:
        return 'Evening motivation and morning reminder';
    }
  }

  static String morningBody(String locale) {
    switch (locale) {
      case 'en':
        return "Good morning! Ready for today's goal?";
      case 'tr':
        return 'Günaydın! Bugünkü hedefin için hazır mısın?';
      default:
        return "Good morning! Ready for today's goal?";
    }
  }
}

/// Bildirim tercihleri ve günlük zamanlanmış bildirimler (akşam motivasyon, sabah hatırlatma).
/// Uygulama genelinde tek instance kullanılmalı (main'de initialize edilir).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const int _idEvening = 1;
  static const int _idMorning = 2;
  static const String _keyEveningEnabled = 'notif_evening_enabled';
  static const String _keyEveningHour = 'notif_evening_hour';
  static const String _keyEveningMinute = 'notif_evening_minute';
  static const String _keyMorningEnabled = 'notif_morning_enabled';
  static const String _keyMorningHour = 'notif_morning_hour';
  static const String _keyMorningMinute = 'notif_morning_minute';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Zaman dilimlerini ve eklentiyi başlat; uygulama açılışında bir kez çağır.
  /// Sadece Android ve iOS'ta native bildirim vardır; Windows/web'de sessizce atlanır.
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      tz_data.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }

      const android = AndroidInitializationSettings('@drawable/ic_notification');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
      );
      const initSettings = InitializationSettings(android: android, iOS: ios);
      await _plugin.initialize(initSettings);

      // İzin veya kanal hatası başarılı init'i bozmasın
      try {
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          await androidPlugin.requestNotificationsPermission();
          final prefs = await _prefs();
          final locale = prefs.getString('appLanguage') ?? 'tr';
          final channel = AndroidNotificationChannel(
            'zone_run_daily',
            _NotificationL10n.channelName(locale),
            description: _NotificationL10n.channelDescription(locale),
            importance: Importance.defaultImportance,
          );
          await androidPlugin.createNotificationChannel(channel);
        }
        final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        if (iosPlugin != null) {
          await iosPlugin.requestPermissions(alert: true, badge: true);
        }
      } catch (_) {
        // İzin/kanal hatası (örn. emülatör): yine de bildirim denemelerini etkinleştir
      }

      _initialized = true;
    } on MissingPluginException catch (_) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('NotificationService: MissingPluginException - native plugin yok (Windows/web veya emülatörde yeniden derle: flutter clean && flutter pub get)');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('NotificationService: PlatformException - ${e.code} ${e.message}');
      }
      if (e.message?.contains('No implementation found') == true) {
        // Desteklenmeyen platform
      } else {
        rethrow;
      }
    }
  }

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  Future<bool> get eveningEnabled async {
    final prefs = await _prefs();
    return prefs.getBool(_keyEveningEnabled) ?? true;
  }

  Future<(int, int)> get eveningTime async {
    final prefs = await _prefs();
    final int h = (prefs.getInt(_keyEveningHour) ?? 18).clamp(0, 23);
    final int m = (prefs.getInt(_keyEveningMinute) ?? 0).clamp(0, 59);
    return (h, m);
  }

  Future<bool> get morningEnabled async {
    final prefs = await _prefs();
    return prefs.getBool(_keyMorningEnabled) ?? true;
  }

  Future<(int, int)> get morningTime async {
    final prefs = await _prefs();
    final int h = (prefs.getInt(_keyMorningHour) ?? 9).clamp(0, 23);
    final int m = (prefs.getInt(_keyMorningMinute) ?? 0).clamp(0, 59);
    return (h, m);
  }

  Future<void> setEvening(bool enabled, int hour, int minute) async {
    final prefs = await _prefs();
    await prefs.setBool(_keyEveningEnabled, enabled);
    await prefs.setInt(_keyEveningHour, hour);
    await prefs.setInt(_keyEveningMinute, minute);
    if (!_initialized) return;
    if (enabled) {
      await _scheduleEvening(hour, minute);
    } else {
      await _plugin.cancel(_idEvening);
    }
  }

  Future<void> setMorning(bool enabled, int hour, int minute) async {
    final prefs = await _prefs();
    await prefs.setBool(_keyMorningEnabled, enabled);
    await prefs.setInt(_keyMorningHour, hour);
    await prefs.setInt(_keyMorningMinute, minute);
    if (!_initialized) return;
    if (enabled) {
      await _scheduleMorning(hour, minute);
    } else {
      await _plugin.cancel(_idMorning);
    }
  }

  /// Uygulama açıldığında çağrılır: akşam bildirimi açıksa bugünkü motivasyon cümlesiyle yeniden zamanla.
  Future<void> refreshSchedulesIfNeeded() async {
    if (!_initialized) return;
    final prefs = await _prefs();
    final eveningOn = prefs.getBool(_keyEveningEnabled) ?? true;
    if (eveningOn) {
      final (h, m) = await eveningTime;
      await _plugin.cancel(_idEvening);
      await _scheduleEvening(h, m);
    }
    final morningOn = prefs.getBool(_keyMorningEnabled) ?? true;
    if (morningOn) {
      final (h, m) = await morningTime;
      await _plugin.cancel(_idMorning);
      await _scheduleMorning(h, m);
    }
  }

  Future<void> _scheduleEvening(int hour, int minute) async {
    if (!_initialized) return;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    final prefs = await _prefs();
    final locale = prefs.getString('appLanguage') ?? 'tr';
    final quote = MotivationQuoteService.getDailyQuote(
      localeCode: locale,
    );
    final androidDetails = AndroidNotificationDetails(
      'zone_run_daily',
      _NotificationL10n.channelName(locale),
      channelDescription: _NotificationL10n.channelDescription(locale),
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      _idEvening,
      '',
      '${quote.quote}\n— ${quote.author}',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleMorning(int hour, int minute) async {
    if (!_initialized) return;
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    final prefs = await _prefs();
    final locale = prefs.getString('appLanguage') ?? 'tr';
    final androidDetails = AndroidNotificationDetails(
      'zone_run_daily',
      _NotificationL10n.channelName(locale),
      channelDescription: _NotificationL10n.channelDescription(locale),
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.zonedSchedule(
      _idMorning,
      '',
      _NotificationL10n.morningBody(locale),
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
