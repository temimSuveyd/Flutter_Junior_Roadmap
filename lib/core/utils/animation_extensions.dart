import 'package:flutter/material.dart';

/// App-wide animation timings and curves.
///
/// Use these instead of hard-coded [Duration] literals so every implicit
/// animation ([AnimatedSwitcher], [AnimatedContainer], [AnimatedOpacity], ...)
/// shares the same rhythm.
class AppDurations {
  const AppDurations._();

  /// Very quick feedback: small toggles, loading indicators.
  static const Duration fast = Duration(milliseconds: 200);

  /// Default transition length: buttons, tabs, icon switchers.
  static const Duration normal = Duration(milliseconds: 300);

  /// Emphasized movement: larger widgets, bottom sheets.
  static const Duration slow = Duration(milliseconds: 500);

  /// Standard route / screen transition length.
  static const Duration page = Duration(milliseconds: 400);

  /// Curve paired with the timings above.
  static const Curve curve = Curves.easeInOut;
}

/// Handy scaling helpers on any [Duration].
extension DurationScalingExtension on Duration {
  /// Half of this duration.
  Duration get half => this ~/ 2;

  /// Double of this duration.
  Duration get twice => this * 2;
}

/// Access the standard animation timings through [BuildContext], e.g.
/// `AnimatedContainer(duration: context.animNormal, ...)`.
extension BuildContextAnimationExtension on BuildContext {
  Duration get animFast => AppDurations.fast;
  Duration get animNormal => AppDurations.normal;
  Duration get animSlow => AppDurations.slow;
  Duration get animPage => AppDurations.page;
  Curve get animCurve => AppDurations.curve;
}

/// Sugar for wrapping a widget in an [AnimatedSwitcher] with the app's default
/// timing and a fade transition.
///
/// Give the returned widget a changing [Key] (or change the child's key) when
/// the content changes, otherwise the switch will not animate.
extension AnimatedWidgetExtensions on Widget {
  AnimatedSwitcher animatedSwitcher({
    Key? key,
    Duration? duration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    Widget Function(Widget, Animation<double>)? transitionBuilder,
  }) =>
      AnimatedSwitcher(
        key: key,
        duration: duration ?? AppDurations.normal,
        switchInCurve: switchInCurve ?? AppDurations.curve,
        switchOutCurve: switchOutCurve ?? AppDurations.curve,
        transitionBuilder: transitionBuilder ??
            (child, animation) => FadeTransition(opacity: animation, child: child),
        child: this,
      );
}
