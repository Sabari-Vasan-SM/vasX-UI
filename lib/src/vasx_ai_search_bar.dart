import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Describes a single menu item in the attachment popup menu of [VasxAiSearchBar].
///
/// Example:
/// ```dart
/// VasxAiAttachmentItem(
///   label: 'Add Photos',
///   icon: Icons.add_a_photo_outlined,
///   onTap: () => _pickPhotos(),
/// )
/// ```
class VasxAiAttachmentItem {
  /// Text label for this menu option.
  final String label;

  /// Icon displayed next to [label].
  final IconData icon;

  /// Callback when this item is tapped.
  final VoidCallback onTap;

  /// Creates a [VasxAiAttachmentItem].
  const VasxAiAttachmentItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

/// A modern AI assistant search bar widget featuring a gradient header title,
/// pill-capsule search box, send action button, and an animated attachment popup menu.
///
/// Example:
/// ```dart
/// VasxAiSearchBar(
///   title: 'What are you looking for today?',
///   subtitle: 'Ask anything about your students & staff',
///   hintText: 'Search settings, students, staff...',
///   attachmentItems: [
///     VasxAiAttachmentItem(
///       label: 'Add Photos',
///       icon: Icons.add_a_photo_outlined,
///       onTap: () {},
///     ),
///     VasxAiAttachmentItem(
///       label: 'Students',
///       icon: Icons.people_outline_rounded,
///       onTap: () {},
///     ),
///   ],
///   onSubmitted: (query) => _handleSearch(query),
/// )
/// ```
class VasxAiSearchBar extends StatefulWidget {
  /// Main title text shown above the search bar.
  /// Rendered with a vibrant gradient ShaderMask.
  final String? title;

  /// Subtitle text shown below [title].
  final String? subtitle;

  /// Placeholder hint text inside the search capsule field.
  final String hintText;

  /// Optional controller managing text value.
  final TextEditingController? controller;

  /// List of items displayed in the attachment popup menu.
  final List<VasxAiAttachmentItem> attachmentItems;

  /// Callback when query text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the send / submit button is pressed or enter key is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Primary color for capsule border, send icon, and active highlights.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Maximum width of the search capsule container. Defaults to `640.0`.
  final double maxWidth;

  /// Creates a [VasxAiSearchBar].
  const VasxAiSearchBar({
    super.key,
    this.title,
    this.subtitle,
    this.hintText = 'Search settings, students, staff...',
    this.controller,
    this.attachmentItems = const [],
    this.onChanged,
    this.onSubmitted,
    this.primaryColor,
    this.maxWidth = 640.0,
  });

  @override
  State<VasxAiSearchBar> createState() => _VasxAiSearchBarState();
}

class _VasxAiSearchBarState extends State<VasxAiSearchBar> {
  late TextEditingController _effectiveController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (widget.controller == null) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (widget.attachmentItems.isEmpty) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) setState(() => _isMenuOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isMenuOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: 210,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(8, 48),
            child: TapRegion(
              groupId: this,
              onTapOutside: (_) => _closeMenu(),
              child: Material(
                elevation: 8,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.black.withValues(alpha: 0.15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: VasxColors.borderLight),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < widget.attachmentItems.length; i++) ...[
                        _buildMenuItem(widget.attachmentItems[i]),
                        if (i < widget.attachmentItems.length - 1)
                          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(VasxAiAttachmentItem item) {
    return InkWell(
      onTap: () {
        _closeMenu();
        item.onTap();
      },
      borderRadius: BorderRadius.circular(16),
      hoverColor: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: VasxColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: VasxColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final text = _effectiveController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.title != null) ...[
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF007A), Color(0xFF9333EA)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              widget.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white, // Masked by ShaderMask
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (widget.subtitle != null) ...[
          Text(
            widget.subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
        ],
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          child: CompositedTransformTarget(
            link: _layerLink,
            child: TapRegion(
              groupId: this,
              onTapOutside: (_) {
                if (_isMenuOpen) _closeMenu();
              },
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _primary, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isMenuOpen ? Icons.close_rounded : Icons.add_rounded,
                        size: 24,
                        color: VasxColors.textPrimary,
                      ),
                      onPressed: widget.attachmentItems.isNotEmpty ? _toggleMenu : null,
                      tooltip: 'Attachment Options',
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: _effectiveController,
                        onChanged: widget.onChanged,
                        onSubmitted: (val) => _submit(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: VasxColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: _primary,
                      ),
                      onPressed: _submit,
                      tooltip: 'Submit Search',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
