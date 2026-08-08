import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// An animated custom toggle switch matching the vasX UI design system.
///
/// Features smooth track color transitions, animated thumb movement, and
/// optional label text.
///
/// Example:
/// ```dart
/// VasxToggle(
///   value: _notificationsEnabled,
///   label: 'Enable Notifications',
///   onChanged: (val) => setState(() => _notificationsEnabled = val),
/// )
/// ```
class VasxToggle extends StatelessWidget {
  /// Whether the toggle is currently active (on).
  final bool value;

  /// Callback when the toggle state changes.
  final ValueChanged<bool>? onChanged;

  /// Optional label text displayed next to the switch.
  final String? label;

  /// Color of the track when [value] is `true`. Defaults to [VasxColors.primary].
  final Color? activeColor;

  /// Color of the track when [value] is `false`. Defaults to `Color(0xFFE2E8F0)`.
  final Color? inactiveTrackColor;

  /// Color of the thumb when [value] is `false`. Defaults to `Color(0xFF64748B)`.
  final Color? inactiveThumbColor;

  /// Whether the toggle control is enabled. Defaults to `true`.
  final bool enabled;

  /// Creates a [VasxToggle].
  const VasxToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
    this.enabled = true,
  });

  Color get _active => activeColor ?? VasxColors.primary;
  Color get _inactiveTrack => inactiveTrackColor ?? const Color(0xFFE2E8F0);
  Color get _inactiveThumb => inactiveThumbColor ?? const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    const double trackWidth = 46.0;
    const double trackHeight = 26.0;
    const double thumbSize = 20.0;
    const double padding = 3.0;

    final isInteractive = enabled && onChanged != null;

    final toggleSwitchWidget = GestureDetector(
      onTap: isInteractive ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: trackWidth,
        height: trackHeight,
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isInteractive
              ? (value ? _active : _inactiveTrack)
              : (value ? _active.withValues(alpha: 0.5) : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: value ? Colors.white : _inactiveThumb,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (label == null) {
      return toggleSwitchWidget;
    }

    return GestureDetector(
      onTap: isInteractive ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          toggleSwitchWidget,
          const SizedBox(width: 12),
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isInteractive ? VasxColors.textPrimary : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
