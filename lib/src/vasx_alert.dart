import 'dart:async';
import 'package:flutter/material.dart';

/// Semantic types for [VasxAlert].
enum VasxAlertType {
  /// Green alert for successful operations.
  success,

  /// Yellow/Amber alert for warnings and cautions.
  warning,

  /// Red alert for errors and critical failures.
  error,

  /// Blue alert for informative messages.
  info,
}

/// Visual style variants for [VasxAlert].
enum VasxAlertVariant {
  /// Solid vibrant background with crisp white text (matching the reference UI).
  solid,

  /// Light subtle background with colored border and text.
  soft,
}

/// Displays an animated [VasxAlert] toast at the top-right corner of the screen.
///
/// The toast slides in smoothly from the right, stays visible for [duration]
/// (defaults to 2 seconds), and then slides out smoothly before unmounting.
///
/// Example:
/// ```dart
/// showVasxAlertToast(
///   context: context,
///   title: 'Logout Successful',
///   message: 'See you soon!',
///   type: VasxAlertType.success,
///   duration: Duration(seconds: 2),
/// );
/// ```
void showVasxAlertToast({
  required BuildContext context,
  required String title,
  String? message,
  VasxAlertType type = VasxAlertType.success,
  VasxAlertVariant variant = VasxAlertVariant.solid,
  Duration duration = const Duration(seconds: 2),
}) {
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => _VasxAlertToastOverlay(
      title: title,
      message: message,
      type: type,
      variant: variant,
      duration: duration,
      onDismiss: () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      },
    ),
  );

  Overlay.of(context).insert(overlayEntry);
}

class _VasxAlertToastOverlay extends StatefulWidget {
  final String title;
  final String? message;
  final VasxAlertType type;
  final VasxAlertVariant variant;
  final Duration duration;
  final VoidCallback onDismiss;

  const _VasxAlertToastOverlay({
    required this.title,
    this.message,
    required this.type,
    required this.variant,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_VasxAlertToastOverlay> createState() => _VasxAlertToastOverlayState();
}

class _VasxAlertToastOverlayState extends State<_VasxAlertToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0.0), // Slide from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    _timer?.cancel();
    if (mounted) {
      await _controller.reverse();
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: 24,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: VasxAlert(
                  title: widget.title,
                  message: widget.message,
                  type: widget.type,
                  variant: widget.variant,
                  onDismiss: _dismiss,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A modern, responsive alert banner component for vasX UI.
///
/// Supports success (green), warning (yellow), error (red), and info (blue)
/// types in solid and soft variants with optional dismiss button and leading icon.
///
/// Example:
/// ```dart
/// VasxAlert(
///   title: 'Logout Successful',
///   message: 'See you soon!',
///   type: VasxAlertType.success,
///   onDismiss: () => _hideAlert(),
/// )
/// ```
class VasxAlert extends StatelessWidget {
  /// Primary title text of the alert banner.
  final String title;

  /// Optional body message displayed below [title].
  final String? message;

  /// Alert semantic type (success, warning, error, info).
  /// Defaults to [VasxAlertType.success].
  final VasxAlertType type;

  /// Visual style variant (solid or soft). Defaults to [VasxAlertVariant.solid].
  final VasxAlertVariant variant;

  /// Custom icon displayed on the left. If omitted, a default icon is used based on [type].
  final IconData? icon;

  /// Callback when the `×` dismiss button is pressed. If omitted, no close button is shown.
  final VoidCallback? onDismiss;

  /// Optional action widget displayed on the right (e.g. [TextButton]).
  final Widget? action;

  /// Border radius of the alert container. Defaults to `16.0`.
  final double borderRadius;

  /// Creates a [VasxAlert].
  const VasxAlert({
    super.key,
    required this.title,
    this.message,
    this.type = VasxAlertType.success,
    this.variant = VasxAlertVariant.solid,
    this.icon,
    this.onDismiss,
    this.action,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final defaultIcon = _getDefaultIcon();

    final Color bgColor = colors.bgColor;
    final Color textColor = colors.textColor;
    final Color iconColor = colors.iconColor;
    final BorderSide borderSide = colors.borderSide;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.fromBorderSide(borderSide),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            message != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (icon != null || defaultIcon != null) ...[
            Icon(
              icon ?? defaultIcon,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 12),
            action!,
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData? _getDefaultIcon() {
    return switch (type) {
      VasxAlertType.success => Icons.check_circle_outline_rounded,
      VasxAlertType.warning => Icons.warning_amber_rounded,
      VasxAlertType.error => Icons.error_outline_rounded,
      VasxAlertType.info => Icons.info_outline_rounded,
    };
  }

  _AlertColors _getColors() {
    if (variant == VasxAlertVariant.solid) {
      return switch (type) {
        VasxAlertType.success => const _AlertColors(
            bgColor: Color(0xFF15803D), // Rich Forest Green
            textColor: Colors.white,
            iconColor: Colors.white,
            borderSide: BorderSide.none,
          ),
        VasxAlertType.warning => const _AlertColors(
            bgColor: Color(0xFFD97706), // Rich Amber / Yellow
            textColor: Colors.white,
            iconColor: Colors.white,
            borderSide: BorderSide.none,
          ),
        VasxAlertType.error => const _AlertColors(
            bgColor: Color(0xFFDC2626), // Rich Red
            textColor: Colors.white,
            iconColor: Colors.white,
            borderSide: BorderSide.none,
          ),
        VasxAlertType.info => const _AlertColors(
            bgColor: Color(0xFF2563EB), // Rich Indigo / Blue
            textColor: Colors.white,
            iconColor: Colors.white,
            borderSide: BorderSide.none,
          ),
      };
    } else {
      return switch (type) {
        VasxAlertType.success => const _AlertColors(
            bgColor: Color(0xFFF0FDF4),
            textColor: Color(0xFF166534),
            iconColor: Color(0xFF16A34A),
            borderSide: BorderSide(color: Color(0xFFBBF7D0)),
          ),
        VasxAlertType.warning => const _AlertColors(
            bgColor: Color(0xFFFFFBEB),
            textColor: Color(0xFF92400E),
            iconColor: Color(0xFFD97706),
            borderSide: BorderSide(color: Color(0xFFFDE68A)),
          ),
        VasxAlertType.error => const _AlertColors(
            bgColor: Color(0xFFFEF2F2),
            textColor: Color(0xFF991B1B),
            iconColor: Color(0xFFDC2626),
            borderSide: BorderSide(color: Color(0xFFFECACA)),
          ),
        VasxAlertType.info => const _AlertColors(
            bgColor: Color(0xFFEFF6FF),
            textColor: Color(0xFF1E40AF),
            iconColor: Color(0xFF2563EB),
            borderSide: BorderSide(color: Color(0xFFBFDBFE)),
          ),
      };
    }
  }
}

class _AlertColors {
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final BorderSide borderSide;

  const _AlertColors({
    required this.bgColor,
    required this.textColor,
    required this.iconColor,
    required this.borderSide,
  });
}
