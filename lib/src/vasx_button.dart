import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Button visual variants available in [VasxButton].
enum VasxButtonVariant {
  /// Solid primary color background with white text/icon.
  primary,

  /// Outlined border with primary color text/icon.
  outlined,

  /// Neutral light border with grey/secondary text/icon.
  secondary,
}

/// Button sizes for [VasxButton].
enum VasxButtonSize {
  /// Height 36 px — compact action button.
  small,

  /// Height 42 px — default action button.
  medium,

  /// Height 48 px — large prominent button.
  large,
}

/// A modern, styled action button component for vasX UI.
///
/// Features solid primary, outlined primary, and secondary neutral styles
/// with optional icon, loading state, and smooth hover/tap feedback.
///
/// Example:
/// ```dart
/// VasxButton(
///   label: 'Create Student',
///   icon: Icons.add,
///   onPressed: () => _createStudent(),
/// )
/// ```
class VasxButton extends StatelessWidget {
  /// Display label text.
  final String label;

  /// Optional icon displayed before [label].
  final IconData? icon;

  /// Button press callback. If `null`, button is disabled.
  final VoidCallback? onPressed;

  /// Button style variant. Defaults to [VasxButtonVariant.primary].
  final VasxButtonVariant variant;

  /// Size preset for height and padding. Defaults to [VasxButtonSize.medium].
  final VasxButtonSize size;

  /// Whether the button is in a loading state. Defaults to `false`.
  final bool isLoading;

  /// Primary color used for background or border/text.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [VasxButton].
  const VasxButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = VasxButtonVariant.primary,
    this.size = VasxButtonSize.medium,
    this.isLoading = false,
    this.primaryColor,
  });

  Color get _primary => primaryColor ?? VasxColors.primary;

  @override
  Widget build(BuildContext context) {
    final double height = switch (size) {
      VasxButtonSize.small => 36.0,
      VasxButtonSize.medium => 42.0,
      VasxButtonSize.large => 48.0,
    };

    final double fontSize = switch (size) {
      VasxButtonSize.small => 13.0,
      VasxButtonSize.medium => 14.0,
      VasxButtonSize.large => 15.0,
    };

    final double iconSize = switch (size) {
      VasxButtonSize.small => 16.0,
      VasxButtonSize.medium => 18.0,
      VasxButtonSize.large => 20.0,
    };

    final EdgeInsets padding = switch (size) {
      VasxButtonSize.small =>
        const EdgeInsets.symmetric(horizontal: 14),
      VasxButtonSize.medium =>
        const EdgeInsets.symmetric(horizontal: 18),
      VasxButtonSize.large =>
        const EdgeInsets.symmetric(horizontal: 22),
    };

    Color bgColor;
    Color fgColor;
    BorderSide borderSide;

    final isEnabled = onPressed != null && !isLoading;

    switch (variant) {
      case VasxButtonVariant.primary:
        bgColor = isEnabled ? _primary : _primary.withValues(alpha: 0.5);
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        break;
      case VasxButtonVariant.outlined:
        bgColor = Colors.white;
        fgColor = isEnabled ? _primary : _primary.withValues(alpha: 0.5);
        borderSide = BorderSide(
          color: isEnabled ? _primary : _primary.withValues(alpha: 0.4),
          width: 1.2,
        );
        break;
      case VasxButtonVariant.secondary:
        bgColor = Colors.white;
        fgColor = isEnabled ? VasxColors.textSecondary : Colors.grey.shade400;
        borderSide = BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        );
        break;
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.fromBorderSide(borderSide),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fgColor,
                  ),
                ),
                const SizedBox(width: 8),
              ] else if (icon != null) ...[
                Icon(icon, size: iconSize, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
