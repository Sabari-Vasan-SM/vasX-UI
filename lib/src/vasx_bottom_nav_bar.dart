import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Item configuration for [VasxMobileBottomNavBar].
class VasxBottomNavItem {
  /// Unique identifier for active state matching.
  final String id;

  /// Display label text shown when item is active.
  final String label;

  /// Display icon.
  final IconData icon;

  /// Optional badge count or tag (e.g. `'3'`).
  final String? badgeText;

  /// Creates a [VasxBottomNavItem].
  const VasxBottomNavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.badgeText,
  });
}

/// A modern, floating pill-style mobile bottom navigation bar component for vasX UI.
///
/// Displays an active item in an expanded soft-blue capsule pill container showing icon
/// and label text, while inactive items display as clean icons in a floating bar.
///
/// Example:
/// ```dart
/// VasxMobileBottomNavBar(
///   selectedId: _currentTab,
///   onItemSelected: (id) => setState(() => _currentTab = id),
///   items: const [
///     VasxBottomNavItem(id: 'dashboard', label: 'Dashboard', icon: Icons.grid_view_rounded),
///     VasxBottomNavItem(id: 'orders', label: 'Orders', icon: Icons.shopping_bag_outlined),
///     VasxBottomNavItem(id: 'customers', label: 'Customers', icon: Icons.people_outline_rounded),
///   ],
/// )
/// ```
class VasxMobileBottomNavBar extends StatelessWidget {
  /// Currently selected item ID.
  final String selectedId;

  /// Navigation items list.
  final List<VasxBottomNavItem> items;

  /// Callback when an item is selected.
  final ValueChanged<String> onItemSelected;

  /// Primary color for active selection pill. Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Background color of floating navigation container. Defaults to [Colors.white].
  final Color? backgroundColor;

  /// Elevation / shadow blur radius. Defaults to `16.0`.
  final double elevation;

  /// Horizontal margin padding around floating container. Defaults to `16.0`.
  final double margin;

  /// Height of the floating container. Defaults to `64.0`.
  final double height;

  /// Creates a [VasxMobileBottomNavBar].
  const VasxMobileBottomNavBar({
    super.key,
    required this.selectedId,
    required this.items,
    required this.onItemSelected,
    this.primaryColor,
    this.backgroundColor,
    this.elevation = 16.0,
    this.margin = 16.0,
    this.height = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = primaryColor ?? VasxColors.primary;
    final navBg = backgroundColor ?? Colors.white;

    return Container(
      margin: EdgeInsets.all(margin),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: navBg,
        borderRadius: BorderRadius.circular(99),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: elevation,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          final isSelected = item.id == selectedId;
          return _buildItem(context, item, isSelected, activeColor);
        }).toList(),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    VasxBottomNavItem item,
    bool isSelected,
    Color activeColor,
  ) {
    final activeBg = activeColor.withValues(alpha: 0.12);
    final inactiveColor = const Color(0xFF64748B);

    return InkWell(
      onTap: () => onItemSelected(item.id),
      borderRadius: BorderRadius.circular(99),
      splashColor: activeColor.withValues(alpha: 0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                if (!isSelected && item.badgeText != null)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        item.badgeText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
