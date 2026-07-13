import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A single-select dropdown with a live search field.
///
/// Opens an overlay panel with a text field for filtering the [items] list.
/// Supports an optional [label] (either a [String] or a [Widget]).
///
/// Example:
/// ```dart
/// SearchableDropdown(
///   label: 'Country',
///   value: _country,
///   hint: 'Select a country',
///   items: countries,
///   onChanged: (val) => setState(() => _country = val),
/// )
/// ```
class SearchableDropdown extends StatefulWidget {
  /// Label shown above the dropdown field. Can be a [String] or a [Widget].
  final Object label;

  /// The currently selected value, or `null` if nothing is selected.
  final String? value;

  /// Placeholder text shown when [value] is `null`.
  final String hint;

  /// The full list of selectable items.
  final List<String> items;

  /// Called when the user selects an item. Passes the selected value or
  /// `null` if cleared.
  final ValueChanged<String?> onChanged;

  /// When `false`, the dropdown cannot be opened. Defaults to `true`.
  final bool enabled;

  /// Primary color used for focused border and selected item highlight.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [SearchableDropdown].
  const SearchableDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.primaryColor,
  });

  @override
  SearchableDropdownState createState() => SearchableDropdownState();
}

/// Public state class for [SearchableDropdown].
class SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  bool _isExpanded = false;
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

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

    Future.microtask(() {
      if (mounted) _focusNode.requestFocus();
    });

    setState(() {
      _isExpanded = true;
      _searchController.clear();
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isExpanded = false);
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
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: StatefulBuilder(
                  builder: (context, setStateOverlay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: VasxColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 300),
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
                                    color: Colors.grey[400], fontSize: 14),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.grey[400], size: 20),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
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
                                  borderSide:
                                      BorderSide(color: _primary),
                                ),
                              ),
                              onChanged: (val) {
                                setStateOverlay(() {});
                              },
                            ),
                          ),
                          const Divider(
                              height: 1, color: VasxColors.borderLight),
                          Flexible(
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children:
                                  _buildOptions(setStateOverlay),
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

  List<Widget> _buildOptions(StateSetter setStateOverlay) {
    final searchQuery = _searchController.text.toLowerCase();
    final matchedItems = widget.items.where((item) {
      return item.toLowerCase().contains(searchQuery);
    }).toList();

    if (matchedItems.isEmpty) {
      return [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            'No matches found.',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }

    return matchedItems.map(_buildOptionTile).toList();
  }

  Widget _buildOptionTile(String item) {
    final isSelected = item == widget.value;

    return InkWell(
      onTap: () {
        widget.onChanged(item);
        _closeDropdown();
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected ? _primary : VasxColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 18, color: _primary),
          ],
        ),
      ),
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
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    Expanded(
                      child: Text(
                        widget.value ?? widget.hint,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.value == null
                              ? Colors.grey[400]
                              : VasxColors.textPrimary,
                        ),
                      ),
                    ),
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
