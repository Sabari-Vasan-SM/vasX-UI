import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A multi-select dropdown with chip display and live search filtering.
///
/// Opens an overlay panel listing all [items]. Selected items appear as
/// removable chips inside the trigger field. Supports an optional [label]
/// (either a [String] or a [Widget]).
///
/// Example:
/// ```dart
/// MultiSelectSearchableDropdown(
///   label: 'Subjects',
///   values: _selectedSubjects,
///   hint: 'Select subjects',
///   items: availableSubjects,
///   onChanged: (vals) => setState(() => _selectedSubjects = vals),
/// )
/// ```
class MultiSelectSearchableDropdown extends StatefulWidget {
  /// Label shown above the dropdown field. Can be a [String] or a [Widget].
  final Object label;

  /// Currently selected values (shown as chips in the trigger field).
  final List<String> values;

  /// Placeholder shown when [values] is empty.
  final String hint;

  /// All available selectable items.
  final List<String> items;

  /// Called whenever the selection changes, passing the updated list.
  final ValueChanged<List<String>> onChanged;

  /// When `false`, the dropdown cannot be opened. Defaults to `true`.
  final bool enabled;

  /// Primary color for selected chips, checkmarks, and active borders.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [MultiSelectSearchableDropdown].
  const MultiSelectSearchableDropdown({
    super.key,
    required this.label,
    required this.values,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.primaryColor,
  });

  @override
  State<MultiSelectSearchableDropdown> createState() =>
      _MultiSelectSearchableDropdownState();
}

class _MultiSelectSearchableDropdownState
    extends State<MultiSelectSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isExpanded = true;
      _searchController.clear();
    });
    Future.microtask(() {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isExpanded = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 8.0),
            child: TapRegion(
              groupId: this,
              onTapOutside: (_) => _closeDropdown(),
              child: Material(
                elevation: 4,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: StatefulBuilder(
                  builder: (context, setStateOverlay) {
                    final searchQuery =
                        _searchController.text.toLowerCase();
                    final filteredItems = widget.items.where((item) {
                      return item.toLowerCase().contains(searchQuery);
                    }).toList();

                    return Container(
                      constraints: const BoxConstraints(maxHeight: 320),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: VasxColors.borderLight),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.grey[400], size: 20),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: VasxColors.borderLight),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: VasxColors.borderLight),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: _primary),
                                ),
                              ),
                              onChanged: (_) => setStateOverlay(() {}),
                            ),
                          ),
                          const Divider(
                              height: 1, color: VasxColors.borderLight),
                          Flexible(
                            child: filteredItems.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 16),
                                    child: Text(
                                      'No matches found.',
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: filteredItems.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(
                                            height: 1,
                                            color: VasxColors.borderLight),
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      final isSelected =
                                          widget.values.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          final next =
                                              List<String>.from(
                                                  widget.values);
                                          if (isSelected) {
                                            next.remove(item);
                                          } else {
                                            next.add(item);
                                          }
                                          widget.onChanged(next);
                                          setStateOverlay(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 16,
                                              vertical: 12),
                                          color: isSelected
                                              ? _primary.withValues(alpha: 0.05)
                                              : Colors.transparent,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: isSelected
                                                        ? _primary
                                                        : const Color(
                                                            0xFF333333),
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(Icons.check,
                                                    size: 18,
                                                    color: _primary),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChips() {
    if (widget.values.isEmpty) {
      return Text(widget.hint,
          style: TextStyle(color: Colors.grey[400], fontSize: 14));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.values.map((value) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: _primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () {
                  final next =
                      List<String>.from(widget.values)..remove(value);
                  widget.onChanged(next);
                },
                child: Icon(Icons.close, size: 14, color: _primary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = widget.label is Widget
        ? widget.label as Widget
        : Text(
            widget.label.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: VasxColors.textPrimary,
            ),
          );

    return TapRegion(
      groupId: this,
      onTapOutside: (_) {
        if (_isExpanded) _closeDropdown();
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelWidget,
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? Colors.white
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isExpanded
                        ? _primary
                        : VasxColors.borderLight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: widget.values.isEmpty
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildChips()),
                    const SizedBox(width: 12),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
