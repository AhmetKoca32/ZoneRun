import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
export 'package:tutorial_coach_mark/tutorial_coach_mark.dart' show ContentAlign;

import '../extensions/theme_extension_helper.dart';
import '../theme/app_typography.dart';

class CoachMarkTarget {
  final GlobalKey key;
  final String text;
  final ContentAlign align;

  const CoachMarkTarget({
    required this.key,
    required this.text,
    this.align = ContentAlign.bottom,
  });
}

class CoachMarkHelper {
  /// true iken onboarding ve coach mark'lar her seferinde gösterilir.
  static const kAlwaysShow = false;

  static Future<bool> shouldShow(String prefKey) async {
    if (kAlwaysShow) return true;
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(prefKey) ?? false);
  }

  static Future<void> markCompleted(String prefKey) async {
    if (kAlwaysShow) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKey, true);
  }

  /// Shows coach marks and returns a Future that completes when the sequence
  /// finishes or is skipped. When [saveOnFinish] is false the prefKey is NOT
  /// persisted (useful for multi-phase flows where only the last phase saves).
  static Future<void> show({
    required BuildContext context,
    required List<CoachMarkTarget> targets,
    required String prefKey,
    bool saveOnFinish = true,
  }) {
    final completer = Completer<void>();

    if (!(context as Element).mounted) {
      completer.complete();
      return completer.future;
    }

    final theme = context.appTheme;

    final validTargets = targets.where((t) {
      final renderBox =
          t.key.currentContext?.findRenderObject() as RenderBox?;
      return renderBox != null && renderBox.hasSize;
    }).toList();

    if (validTargets.isEmpty) {
      completer.complete();
      return completer.future;
    }

    final focusTargets = validTargets.map((target) {
      return TargetFocus(
        identify: target.key.toString(),
        keyTarget: target.key,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: target.align,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    target.text,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.medium,
                      height: 1.4,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      );
    }).toList();

    try {
      TutorialCoachMark(
        targets: focusTargets,
        colorShadow: theme.primaryBackground,
        opacityShadow: 0.85,
        hideSkip: true,
        onFinish: () {
          if (saveOnFinish) markCompleted(prefKey);
          if (!completer.isCompleted) completer.complete();
        },
        onSkip: () {
          markCompleted(prefKey);
          if (!completer.isCompleted) completer.complete();
          return true;
        },
      ).show(context: context);
    } catch (_) {
      if (!completer.isCompleted) completer.complete();
    }

    return completer.future;
  }
}
