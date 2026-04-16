import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService.instance;
  bool _loading = true;
  bool _eveningEnabled = false;
  int _eveningHour = 18;
  int _eveningMinute = 0;
  bool _morningEnabled = false;
  int _morningHour = 9;
  int _morningMinute = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final eveningOn = await _notificationService.eveningEnabled;
    final eveningTime = await _notificationService.eveningTime;
    final morningOn = await _notificationService.morningEnabled;
    final morningTime = await _notificationService.morningTime;
    if (mounted) {
      setState(() {
        _eveningEnabled = eveningOn;
        _eveningHour = eveningTime.$1;
        _eveningMinute = eveningTime.$2;
        _morningEnabled = morningOn;
        _morningHour = morningTime.$1;
        _morningMinute = morningTime.$2;
        _loading = false;
      });
    }
  }

  Future<void> _pickTime(bool isEvening) async {
    int hour = isEvening ? _eveningHour : _morningHour;
    int minute = isEvening ? _eveningMinute : _morningMinute;
    final theme = context.appTheme;

    final picked = await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _TimePickerSheet(
        initialHour: hour,
        initialMinute: minute,
        theme: theme,
      ),
    );
    if (picked == null || !mounted) return;
    if (isEvening) {
      setState(() {
        _eveningHour = picked.hour;
        _eveningMinute = picked.minute;
      });
      await _notificationService.setEvening(_eveningEnabled, _eveningHour, _eveningMinute);
    } else {
      setState(() {
        _morningHour = picked.hour;
        _morningMinute = picked.minute;
      });
      await _notificationService.setMorning(_morningEnabled, _morningHour, _morningMinute);
    }
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: _appBar(theme, l10n),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: _appBar(theme, l10n),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationsEveningTitle,
              style: AppTypography.titleMedium.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.notificationsEveningDescription,
              style: AppTypography.bodySmall.copyWith(
                color: theme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              theme: theme,
              enabled: _eveningEnabled,
              timeText: _formatTime(_eveningHour, _eveningMinute),
              onToggle: (v) async {
                setState(() => _eveningEnabled = v);
                await _notificationService.setEvening(v, _eveningHour, _eveningMinute);
              },
              onTimeTap: () => _pickTime(true),
              timeLabel: l10n.notificationsTimeLabel,
            ),
            const SizedBox(height: 28),
            Text(
              l10n.notificationsMorningTitle,
              style: AppTypography.titleMedium.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.notificationsMorningDescription,
              style: AppTypography.bodySmall.copyWith(
                color: theme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              theme: theme,
              enabled: _morningEnabled,
              timeText: _formatTime(_morningHour, _morningMinute),
              onToggle: (v) async {
                setState(() => _morningEnabled = v);
                await _notificationService.setMorning(v, _morningHour, _morningMinute);
              },
              onTimeTap: () => _pickTime(false),
              timeLabel: l10n.notificationsTimeLabel,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(dynamic theme, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: theme.textPrimary, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        l10n.notificationsTitle,
        style: AppTypography.headlineSmall.copyWith(
          color: theme.textPrimary,
          fontWeight: AppTypography.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildCard({
    required dynamic theme,
    required bool enabled,
    required String timeText,
    required ValueChanged<bool> onToggle,
    required VoidCallback onTimeTap,
    required String timeLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeLabel,
                      style: AppTypography.labelMedium.copyWith(
                        color: theme.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Switch.adaptive(
                      value: enabled,
                      onChanged: onToggle,
                      activeColor: theme.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Material(
                  color: theme.primaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onTimeTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.schedule_rounded,
                              color: theme.accent,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            timeText,
                            style: AppTypography.titleLarge.copyWith(
                              color: theme.textPrimary,
                              fontWeight: AppTypography.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.edit_calendar_rounded,
                            color: theme.textTertiary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Modern saat seçici bottom sheet (Cupertino tarzı tekerlek + Tamam butonu)
class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({
    required this.initialHour,
    required this.initialMinute,
    required this.theme,
  });

  final int initialHour;
  final int initialMinute;
  final dynamic theme;

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
  }

  void _onTimerDurationChanged(Duration d) {
    setState(() {
      _hour = d.inHours % 24;
      _minute = d.inMinutes % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final l10n = AppLocalizations.of(context)!;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.border.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.notificationsPickTimeTitle,
              style: AppTypography.titleLarge.copyWith(
                color: theme.textPrimary,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
              style: AppTypography.headlineMedium.copyWith(
                color: theme.accent,
                fontWeight: AppTypography.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(
              height: 220,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(context).brightness,
                  primaryColor: theme.accent,
                ),
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                    hours: _hour,
                    minutes: _minute,
                  ),
                  onTimerDurationChanged: _onTimerDurationChanged,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + safeBottom),
                child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      TimeOfDay(hour: _hour, minute: _minute),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.accent,
                    foregroundColor: theme.primaryBackground,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(l10n.notificationsDone),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
