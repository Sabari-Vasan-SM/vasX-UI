import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A dropdown that lets users select an existing item **or create a new one**
/// inline without leaving the form.
///
/// Opens an overlay with the existing [items] list and an "Add new item"
/// section at the bottom. When the user types a name and presses the + button
/// (or the Enter key), [onAddItem] is called so the parent can persist the
/// new item. The optional [onRemoveItem] callback enables per-item delete
/// buttons in the list.
///
/// Example:
/// ```dart
/// CreatableDropdown(
///   value: _selectedClass,
///   items: _classes,
///   onChanged: (val) => setState(() => _selectedClass = val),
///   onAddItem: (newClass) {
///     setState(() => _classes.add(newClass));
///     _selectedClass = newClass;
///   },
///   onRemoveItem: (cls) => setState(() => _classes.remove(cls)),
/// )
/// ```
class CreatableDropdown extends StatefulWidget {
  /// The currently selected value (shown in the trigger field).
  final String value;

  /// All existing selectable items.
  final List<String> items;

  /// Called when the user picks an existing item.
  final ValueChanged<String> onChanged;

  /// Called when the user creates a new item via the inline text field.
  final ValueChanged<String> onAddItem;

  /// Optional. Called when the user taps the × icon next to an item.
  /// If `null`, no delete button is shown.
  final ValueChanged<String>? onRemoveItem;

  /// Primary color for the active border, add button, and focused input.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [CreatableDropdown].
  const CreatableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onAddItem,
    this.onRemoveItem,
    this.primaryColor,
  });

  @override
  CreatableDropdownState createState() => CreatableDropdownState();
}

/// Public state class for [CreatableDropdown].
class CreatableDropdownState extends State<CreatableDropdown> {
  bool _isExpanded = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _addController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _addController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) setState(() => _isExpanded = true);
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
            offset: Offset(0.0, size.height + 4.0),
            child: TapRegion(
              groupId: this,
              onTapOutside: (_) => _closeDropdown(),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = item == widget.value;
                            return InkWell(
                              onTap: () {
                                widget.onChanged(item);
                                _closeDropdown();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                color: isSelected
                                    ? Colors.grey.shade100
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    if (widget.onRemoveItem != null)
                                      InkWell(
                                        onTap: () =>
                                            widget.onRemoveItem!(item),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add new item',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                      border: Border.all(
                                          color: _primary),
                                    ),
                                    child: TextField(
                                      controller: _addController,
                                      focusNode: _focusNode,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter item name',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 13),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (_) {
                                        if (_addController.text
                                            .trim()
                                            .isNotEmpty) {
                                          widget.onAddItem(
                                              _addController.text.trim());
                                          _addController.clear();
                                          _closeDropdown();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    if (_addController.text
                                        .trim()
                                        .isNotEmpty) {
                                      widget.onAddItem(
                                          _addController.text.trim());
                                      _addController.clear();
                                      _closeDropdown();
                                    }
                                  },
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: _primary,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Press Enter to add',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: this,
      onTapOutside: (_) {
        if (_isExpanded) _closeDropdown();
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: _isExpanded
                      ? _primary
                      : Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
