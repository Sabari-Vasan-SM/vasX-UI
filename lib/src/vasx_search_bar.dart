import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A sleek search input field matching the vasX UI toolbar design system.
///
/// Example:
/// ```dart
/// VasxSearchBar(
///   hintText: 'Search...',
///   onChanged: (q) => setState(() => _searchQuery = q),
/// )
/// ```
class VasxSearchBar extends StatefulWidget {
  /// Controller managing the text value. If omitted, an internal controller is used.
  final TextEditingController? controller;

  /// Placeholder hint text. Defaults to `'Search...'`.
  final String hintText;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the clear (×) button is tapped.
  final VoidCallback? onClear;

  /// Width of the search bar. Defaults to `260.0`. Omit or set to `null` to expand.
  final double? width;

  /// Primary color used for the focused border. Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [VasxSearchBar].
  const VasxSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.width = 260.0,
    this.primaryColor,
  });

  @override
  State<VasxSearchBar> createState() => _VasxSearchBarState();
}

class _VasxSearchBarState extends State<VasxSearchBar> {
  late TextEditingController _effectiveController;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _effectiveController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _effectiveController.dispose();
    } else {
      _effectiveController.removeListener(_onTextChange);
    }
    super.dispose();
  }

  void _onTextChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final searchInput = SizedBox(
      height: 42,
      child: TextField(
        controller: _effectiveController,
        onChanged: widget.onChanged,
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
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.grey[400],
          ),
          suffixIcon: _effectiveController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, size: 16, color: Colors.grey[500]),
                  onPressed: () {
                    _effectiveController.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _primary, width: 1.5),
          ),
        ),
      ),
    );

    if (widget.width == null) {
      return searchInput;
    }

    return SizedBox(width: widget.width, child: searchInput);
  }
}
