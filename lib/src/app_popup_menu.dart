import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Describes a single item in an [AppPopupMenu].
///
/// Each item has a [label], an optional icon (either an asset path via
/// [iconPath] or a material [icon]), a tap callback [onTap], and an optional
/// [isDestructive] flag that renders the item in red.
///
/// Example:
/// ```dart
/// AppPopupMenuItem(
///   label: 'Delete',
///   icon: Icons.delete_outline,
///   isDestructive: true,
///   onTap: () => _deleteItem(),
/// )
/// ```
class AppPopupMenuItem {
  /// The display text for this menu item.
  final String label;

  /// Optional asset image path. Shown as a 22×22 [Image.asset].
  /// If [iconPath] is set it takes priority over [icon].
  final String? iconPath;

  /// Optional [IconData] shown as a 22 pt [Icon].
  /// Ignored when [iconPath] is also provided.
  final IconData? icon;

  /// Callback invoked when the user taps this item.
  final VoidCallback onTap;

  /// When `true`, the label and icon are rendered in [VasxColors.destructive]
  /// to signal a dangerous action (e.g. delete, remove).
  final bool isDestructive;

  /// Creates an [AppPopupMenuItem].
  const AppPopupMenuItem({
    required this.label,
    this.iconPath,
    this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}

/// An animated, themed popup action menu.
///
/// Renders a list of [AppPopupMenuItem]s inside a floating card that
/// animates in with a scale + fade transition. Typically shown via an
/// [OverlayEntry] triggered by a "more options" button.
///
/// Example:
/// ```dart
/// AppPopupMenu(
///   onClose: () => overlayEntry.remove(),
///   items: [
///     AppPopupMenuItem(
///       label: 'Edit',
///       icon: Icons.edit_outlined,
///       onTap: () => _onEdit(),
///     ),
///     AppPopupMenuItem(
///       label: 'Delete',
///       icon: Icons.delete_outline,
///       isDestructive: true,
///       onTap: () => _onDelete(),
///     ),
///   ],
/// )
/// ```
class AppPopupMenu extends StatefulWidget {
  /// The list of items to display in the menu.
  final List<AppPopupMenuItem> items;

  /// Called when the menu requests to be closed (e.g. after a tap).
  /// Use this to remove the [OverlayEntry] that hosts this widget.
  final VoidCallback onClose;

  /// Width of the popup card in logical pixels. Defaults to `200`.
  final double width;

  /// Creates an [AppPopupMenu].
  const AppPopupMenu({
    super.key,
    required this.items,
    required this.onClose,
    this.width = 200,
  });

  @override
  State<AppPopupMenu> createState() => _AppPopupMenuState();
}

class _AppPopupMenuState extends State<AppPopupMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: VasxColors.borderLight, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.items.length; i++) ...[
                  _buildMenuItem(widget.items[i]),
                  if (i < widget.items.length - 1)
                    Divider(height: 1, thickness: 1, color: Colors.grey[100]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(AppPopupMenuItem item) {
    return InkWell(
      onTap: () {
        widget.onClose();
        item.onTap();
      },
      hoverColor: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (item.iconPath != null)
              Image.asset(
                item.iconPath!,
                width: 22,
                height: 22,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_outlined,
                  size: 22,
                  color: item.isDestructive
                      ? VasxColors.destructive
                      : VasxColors.textSecondary,
                ),
              )
            else if (item.icon != null)
              Icon(
                item.icon,
                size: 22,
                color: item.isDestructive
                    ? VasxColors.destructive
                    : VasxColors.textSecondary,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: item.isDestructive
                      ? VasxColors.destructive
                      : VasxColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
