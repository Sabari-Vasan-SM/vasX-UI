import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Item configuration for [VasxSideMenu].
class VasxSideMenuItem {
  /// Unique identifier for active state matching.
  final String id;

  /// Display label text.
  final String label;

  /// Leading icon.
  final IconData icon;

  /// Optional badge text (e.g. `'12'`).
  final String? badgeText;

  /// Whether this item is destructive (e.g. Logout). Defaults to `false`.
  final bool isDestructive;

  /// Optional sub-items for nested submenus.
  final List<VasxSideMenuItem>? subItems;

  /// Creates a [VasxSideMenuItem].
  const VasxSideMenuItem({
    required this.id,
    required this.label,
    required this.icon,
    this.badgeText,
    this.isDestructive = false,
    this.subItems,
  });
}

/// A sleek, responsive side navigation menu widget matching modern SaaS admin panels.
///
/// Features smooth hover-based auto-expansion and collapse (from 72px icon mode
/// to 250px full expanded mode), active item highlight, badge counts, and bottom action section.
///
/// Example:
/// ```dart
/// VasxSideMenu(
///   brandName: 'Test Shop',
///   selectedId: 'dashboard',
///   items: const [
///     VasxSideMenuItem(id: 'dashboard', label: 'Dashboard', icon: Icons.grid_view_rounded),
///     VasxSideMenuItem(id: 'orders', label: 'My Orders', icon: Icons.shopping_bag_outlined),
///   ],
///   onItemSelected: (id) => setState(() => _selected = id),
/// )
/// ```
class VasxSideMenu extends StatefulWidget {
  /// Logo or brand icon widget displayed at top left.
  final Widget? logoWidget;

  /// Brand name title displayed next to logo when expanded.
  final String? brandName;

  /// ID of the currently active item.
  final String selectedId;

  /// Main list of navigation items.
  final List<VasxSideMenuItem> items;

  /// Bottom section navigation items (e.g. Settings, Logout).
  final List<VasxSideMenuItem> bottomItems;

  /// Callback when a navigation item is selected.
  final ValueChanged<String>? onItemSelected;

  /// Width of sidebar when expanded. Defaults to `250.0`.
  final double expandedWidth;

  /// Width of sidebar when collapsed in icon mode. Defaults to `72.0`.
  final double collapsedWidth;

  /// Whether mouse hover triggers auto-expansion and collapse. Defaults to `true`.
  final bool expandOnHover;

  /// Primary color for active selection highlight. Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Background color of sidebar. Defaults to `Color(0xFFF8FAFC)`.
  final Color? backgroundColor;

  /// Creates a [VasxSideMenu].
  const VasxSideMenu({
    super.key,
    this.logoWidget,
    this.brandName,
    required this.selectedId,
    required this.items,
    this.bottomItems = const [],
    this.onItemSelected,
    this.expandedWidth = 250.0,
    this.collapsedWidth = 72.0,
    this.expandOnHover = true,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<VasxSideMenu> createState() => _VasxSideMenuState();
}

class _VasxSideMenuState extends State<VasxSideMenu> {
  bool _isHovered = false;
  final Map<String, bool> _expandedSubmenus = {};

  Color get _primary => widget.primaryColor ?? VasxColors.primary;
  Color get _bg => widget.backgroundColor ?? const Color(0xFFF8FAFC);

  bool get _isExpanded => !widget.expandOnHover || _isHovered;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.expandOnHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.expandOnHover ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: _isExpanded ? widget.expandedWidth : widget.collapsedWidth,
        decoration: BoxDecoration(
          color: _bg,
          border: Border(
            right: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          boxShadow: _isHovered && widget.expandOnHover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(4, 0),
                  ),
                ]
              : [],
        ),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      for (final item in widget.items) ...[
                        _buildMenuItem(item),
                        const SizedBox(height: 4),
                      ],
                    ],
                  ),
                ),
              ),
              if (widget.bottomItems.isNotEmpty) ...[
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      for (final item in widget.bottomItems) ...[
                        _buildMenuItem(item),
                        const SizedBox(height: 4),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final double contentWidth = widget.expandedWidth - 28;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRect(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: contentWidth,
            child: Row(
              children: [
                widget.logoWidget ??
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                if (_isExpanded && widget.brandName != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.brandName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(VasxSideMenuItem item, {bool isSubItem = false}) {
    final isSelected = widget.selectedId == item.id;
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;
    final isSubmenuExpanded = _expandedSubmenus[item.id] ?? false;

    Color itemColor;
    if (item.isDestructive) {
      itemColor = const Color(0xFFDC2626); // Red
    } else if (isSelected) {
      itemColor = _primary;
    } else {
      itemColor = const Color(0xFF475569); // Slate grey
    }

    Color bgColor;
    if (isSelected) {
      bgColor = _primary.withValues(alpha: 0.12);
    } else {
      bgColor = Colors.transparent;
    }

    final double contentWidth = widget.expandedWidth - (isSubItem ? 48 : 36);

    return Column(
      children: [
        Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              if (hasSubItems) {
                setState(() {
                  _expandedSubmenus[item.id] = !isSubmenuExpanded;
                });
              } else {
                widget.onItemSelected?.call(item.id);
              }
            },
            borderRadius: BorderRadius.circular(10),
            hoverColor: isSelected ? null : Colors.black.withValues(alpha: 0.04),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRect(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: contentWidth,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: isSubItem ? 18 : 22,
                                color: itemColor,
                              ),
                              if (isSelected && !_isExpanded)
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 3,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (_isExpanded) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.label,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: itemColor,
                              ),
                            ),
                          ),
                          if (item.badgeText != null) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _primary
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                item.badgeText!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                          if (hasSubItems) ...[
                            const SizedBox(width: 4),
                            Icon(
                              isSubmenuExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasSubItems && isSubmenuExpanded && _isExpanded) ...[
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: [
                for (final subItem in item.subItems!) ...[
                  _buildMenuItem(subItem, isSubItem: true),
                  const SizedBox(height: 2),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
