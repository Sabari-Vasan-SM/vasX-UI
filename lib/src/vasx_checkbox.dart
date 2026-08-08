import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A custom, styled checkbox widget matching the vasX UI design system.
///
/// Renders a rounded-corner square checkbox with smooth fill and checkmark
/// animation, supporting active state, inactive outline state, and optional label.
///
/// Example:
/// ```dart
/// VasxCheckbox(
///   value: _agreeToTerms,
///   label: 'I agree to the terms and conditions',
///   onChanged: (val) => setState(() => _agreeToTerms = val),
/// )
/// ```
class VasxCheckbox extends StatelessWidget {
  /// Whether the checkbox is currently checked.
  final bool value;

  /// Callback when the checked state changes.
  final ValueChanged<bool>? onChanged;

  /// Optional text label displayed beside the checkbox.
  final String? label;

  /// Primary color when checked. Defaults to [VasxColors.primary].
  final Color? activeColor;

  /// Border color when unchecked. Defaults to `Color(0xFFCBD5E1)`.
  final Color? uncheckedBorderColor;

  /// Whether the control is enabled. Defaults to `true`.
  final bool enabled;

  /// Creates a [VasxCheckbox].
  const VasxCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.uncheckedBorderColor,
    this.enabled = true,
  });

  Color get _active => activeColor ?? VasxColors.primary;
  Color get _borderColor => uncheckedBorderColor ?? const Color(0xFFCBD5E1);

  @override
  Widget build(BuildContext context) {
    const double size = 22.0;

    final isInteractive = enabled && onChanged != null;

    final checkboxWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value
            ? (isInteractive ? _active : _active.withValues(alpha: 0.5))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: value ? _active : _borderColor,
          width: value ? 1.5 : 2.0,
        ),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: value ? 1.0 : 0.0,
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    );

    if (label == null) {
      return GestureDetector(
        onTap: isInteractive ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: checkboxWidget,
      );
    }

    return GestureDetector(
      onTap: isInteractive ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          checkboxWidget,
          const SizedBox(width: 10),
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
