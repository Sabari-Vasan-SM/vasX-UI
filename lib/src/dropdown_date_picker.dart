import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// A date picker composed of three separate dropdowns: **Year**, **Month**,
/// and **Day**.
///
/// The selected date is stored in the provided [controller] in the format
/// specified by [dateFormat] (`'dd/MM/yyyy'` by default, or `'yyyy-MM-dd'`).
/// Day count automatically adjusts when the selected month or year changes
/// (e.g. February in a leap year → 29 days).
///
/// Example:
/// ```dart
/// DropdownDatePicker(
///   controller: _dobController,
///   label: 'Date of Birth',
///   startYear: 1950,
///   endYear: 2010,
/// )
/// ```
class DropdownDatePicker extends StatefulWidget {
  /// [TextEditingController] that holds and receives the selected date string.
  final TextEditingController controller;

  /// Optional label shown above the dropdowns. Can be a [String] or a
  /// [Widget]. Omit or pass `null` to hide the label.
  final Object? label;

  /// When `false`, all three dropdowns are disabled. Defaults to `true`.
  final bool enabled;

  /// Earliest year available in the Year dropdown. Defaults to `1950`.
  final int startYear;

  /// Latest year initially available. Defaults to `2030` or the current year
  /// (whichever is greater). Can be extended by the user via the
  /// "More Years" button when [showExtendYears] is `true`.
  final int? endYear;

  /// Format of the date written to [controller].
  /// - `'dd/MM/yyyy'` (default)
  /// - `'yyyy-MM-dd'`
  final String dateFormat;

  /// When `true`, a "More Years" button is shown that extends [endYear]
  /// by 10 years on each tap. Defaults to `false`.
  final bool showExtendYears;

  /// Primary color for focused dropdown borders and the "More Years" link.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [DropdownDatePicker].
  const DropdownDatePicker({
    super.key,
    required this.controller,
    this.label,
    this.enabled = true,
    this.startYear = 1950,
    this.endYear,
    this.dateFormat = 'dd/MM/yyyy',
    this.showExtendYears = false,
    this.primaryColor,
  });

  @override
  State<DropdownDatePicker> createState() => _DropdownDatePickerState();
}

class _DropdownDatePickerState extends State<DropdownDatePicker> {
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  late int _dynamicEndYear;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const List<String> _monthAbbrev = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _dynamicEndYear = widget.endYear ?? 2030;
    if (_dynamicEndYear < DateTime.now().year) {
      _dynamicEndYear = DateTime.now().year;
    }
    _parseController();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => _parseController();

  void _parseController() {
    if (!mounted) return;
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      if (_selectedDay != null ||
          _selectedMonth != null ||
          _selectedYear != null) {
        setState(() {
          _selectedDay = null;
          _selectedMonth = null;
          _selectedYear = null;
        });
      }
      return;
    }

    int? day, month, year;

    final slashParts = text.split('/');
    if (slashParts.length == 3) {
      day = int.tryParse(slashParts[0]);
      month = int.tryParse(slashParts[1]);
      year = int.tryParse(slashParts[2]);
    }

    if (day == null || month == null || year == null) {
      final dashParts = text.split('-');
      if (dashParts.length == 3) {
        year = int.tryParse(dashParts[0]);
        month = int.tryParse(dashParts[1]);
        day = int.tryParse(dashParts[2]);
      }
    }

    if (day != null && month != null && year != null) {
      if (_selectedDay != day ||
          _selectedMonth != month ||
          _selectedYear != year) {
        setState(() {
          _selectedDay = day;
          _selectedMonth = month;
          _selectedYear = year;
        });
      }
    }
  }

  int _daysInMonth(int month, int year) =>
      DateUtils.getDaysInMonth(year, month);

  List<int> get _days {
    if (_selectedMonth == null || _selectedYear == null) {
      return List.generate(31, (i) => i + 1);
    }
    final count = _daysInMonth(_selectedMonth!, _selectedYear!);
    return List.generate(count, (i) => i + 1);
  }

  List<int> get _years {
    final end = _dynamicEndYear;
    final start = widget.startYear;
    return List.generate(end - start + 1, (i) => end - i);
  }

  void _extendYears() => setState(() => _dynamicEndYear += 10);

  void _updateController() {
    if (_selectedDay != null &&
        _selectedMonth != null &&
        _selectedYear != null) {
      final maxDay = _daysInMonth(_selectedMonth!, _selectedYear!);
      if (_selectedDay! > maxDay) _selectedDay = maxDay;

      if (widget.dateFormat == 'yyyy-MM-dd') {
        widget.controller.text =
            '${_selectedYear.toString().padLeft(4, '0')}-'
            '${_selectedMonth.toString().padLeft(2, '0')}-'
            '${_selectedDay.toString().padLeft(2, '0')}';
      } else {
        widget.controller.text =
            '${_selectedDay.toString().padLeft(2, '0')}/'
            '${_selectedMonth.toString().padLeft(2, '0')}/'
            '$_selectedYear';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? labelWidget;
    if (widget.label != null) {
      if (widget.label is Widget) {
        labelWidget = widget.label as Widget;
      } else {
        labelWidget = Text(
          widget.label.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: VasxColors.textPrimary,
          ),
        );
      }
    }

    const disabledColor = Color(0xFFF0F0F0);
    const enabledColor = Colors.white;
    final fillColor = widget.enabled ? enabledColor : disabledColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelWidget != null) ...[
          labelWidget,
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            // Year dropdown
            Expanded(
              flex: 3,
              child: _buildDropdown<int>(
                value: _selectedYear,
                hint: 'Year',
                items: _years
                    .map((y) => DropdownMenuItem<int>(
                          value: y,
                          child: Text(y.toString(),
                              style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) => _years
                    .map((y) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(y.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: VasxColors.textPrimary)),
                        ))
                    .toList(),
                onChanged: widget.enabled
                    ? (val) {
                        setState(() {
                          _selectedYear = val;
                          if (_selectedDay != null &&
                              _selectedMonth != null) {
                            final maxDay =
                                _daysInMonth(_selectedMonth!, val!);
                            if (_selectedDay! > maxDay) {
                              _selectedDay = maxDay;
                            }
                          }
                        });
                        _updateController();
                      }
                    : null,
                fillColor: fillColor,
              ),
            ),
            const SizedBox(width: 6),
            // Month dropdown
            Expanded(
              flex: 3,
              child: _buildDropdown<int>(
                value: _selectedMonth,
                hint: 'Month',
                items: List.generate(
                    12,
                    (i) => DropdownMenuItem<int>(
                          value: i + 1,
                          child: Text(_monthNames[i],
                              style: const TextStyle(fontSize: 13)),
                        )),
                selectedItemBuilder: (context) => List.generate(
                    12,
                    (i) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(_monthAbbrev[i],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: VasxColors.textPrimary)),
                        )),
                onChanged: widget.enabled
                    ? (val) {
                        setState(() {
                          _selectedMonth = val;
                          if (_selectedDay != null &&
                              _selectedYear != null) {
                            final maxDay =
                                _daysInMonth(val!, _selectedYear!);
                            if (_selectedDay! > maxDay) {
                              _selectedDay = maxDay;
                            }
                          }
                        });
                        _updateController();
                      }
                    : null,
                fillColor: fillColor,
              ),
            ),
            const SizedBox(width: 6),
            // Day dropdown
            Expanded(
              flex: 3,
              child: _buildDropdown<int>(
                value: _selectedDay,
                hint: 'Day',
                items: _days
                    .map((d) => DropdownMenuItem<int>(
                          value: d,
                          child: Text(d.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) => _days
                    .map((d) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(d.toString().padLeft(2, '0'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: VasxColors.textPrimary)),
                        ))
                    .toList(),
                onChanged: widget.enabled
                    ? (val) {
                        setState(() => _selectedDay = val);
                        _updateController();
                      }
                    : null,
                fillColor: fillColor,
              ),
            ),
          ],
        ),
        if (widget.showExtendYears && widget.enabled)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _extendYears,
                behavior: HitTestBehavior.opaque,
                child: Tooltip(
                  message:
                      'Extend year range to ${_dynamicEndYear + 10}',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline,
                          size: 14, color: _primary),
                      const SizedBox(width: 4),
                      Text(
                        'More Years',
                        style: TextStyle(
                          fontSize: 12,
                          color: _primary,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?>? onChanged,
    required Color fillColor,
    List<Widget> Function(BuildContext)? selectedItemBuilder,
  }) {
    final validValue =
        items.any((item) => item.value == value) ? value : null;

    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<T>(
        initialValue: validValue,
        hint: Text(hint,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
            overflow: TextOverflow.ellipsis),
        items: items,
        selectedItemBuilder: selectedItemBuilder,
        onChanged: onChanged,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down,
            size: 16, color: Colors.grey[500]),
        style: const TextStyle(
            fontSize: 13, color: VasxColors.textPrimary),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        menuMaxHeight: 300,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VasxColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VasxColors.borderLight),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: VasxColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primary),
          ),
          filled: true,
          fillColor: fillColor,
        ),
      ),
    );
  }
}
