import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'vasx_colors.dart';

/// Shows a [CustomDateRangePickerDialog] and returns the selected
/// [DateTimeRange], or `null` if the user cancels.
///
/// Example:
/// ```dart
/// final range = await showCustomDateRangePicker(
///   context: context,
///   initialDateRange: _selectedRange,
/// );
/// if (range != null) setState(() => _selectedRange = range);
/// ```
Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,

  /// Pre-selected range shown when the dialog opens.
  DateTimeRange? initialDateRange,

  /// Primary color used for selected-day highlights and the Apply button.
  /// Defaults to [VasxColors.primary].
  Color? primaryColor,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CustomDateRangePickerDialog(
      initialDateRange: initialDateRange,
      primaryColor: primaryColor,
    ),
  );
}

/// A dual-calendar date range picker rendered inside a [Dialog].
///
/// **Desktop:** Two side-by-side calendars (FROM / TO).
/// **Mobile (< 600 px):** Two stacked calendars.
///
/// Users tap a start date then an end date; tapping again resets the
/// selection. The selected range is highlighted with a blue band.
///
/// Typically shown via [showCustomDateRangePicker] rather than directly.
class CustomDateRangePickerDialog extends StatefulWidget {
  /// Initial date range to pre-select when the dialog opens.
  final DateTimeRange? initialDateRange;

  /// Primary color for selection highlights and the Apply button.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Creates a [CustomDateRangePickerDialog].
  const CustomDateRangePickerDialog({
    Key? key,
    this.initialDateRange,
    this.primaryColor,
  }) : super(key: key);

  @override
  CustomDateRangePickerDialogState createState() =>
      CustomDateRangePickerDialogState();
}

/// Public state class for [CustomDateRangePickerDialog].
class CustomDateRangePickerDialogState
    extends State<CustomDateRangePickerDialog> {
  late DateTime _currentMonthLeft;
  late DateTime _currentMonthRight;
  DateTime? _startDate;
  DateTime? _endDate;

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.initialDateRange != null) {
      _startDate = widget.initialDateRange!.start;
      _endDate = widget.initialDateRange!.end;
      _currentMonthLeft =
          DateTime(_startDate!.year, _startDate!.month);
      _currentMonthRight = DateTime(
          _currentMonthLeft.year, _currentMonthLeft.month + 1);
    } else {
      _currentMonthLeft = DateTime(now.year, now.month);
      _currentMonthRight = DateTime(now.year, now.month + 1);
    }
  }

  void _onDayTapped(DateTime date) {
    setState(() {
      if (_startDate == null) {
        _startDate = date;
        _endDate = null;
      } else if (_endDate == null) {
        if (date.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
      } else {
        _startDate = date;
        _endDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: isMobile ? 350 : 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isMobile
                ? Column(
                    children: [
                      _buildCalendarPane(
                        isLeft: true,
                        currentMonth: _currentMonthLeft,
                        onMonthChanged: (newMonth) {
                          setState(() {
                            _currentMonthLeft = newMonth;
                            if (!_currentMonthRight
                                .isAfter(_currentMonthLeft)) {
                              _currentMonthRight = DateTime(
                                  newMonth.year, newMonth.month + 1);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildCalendarPane(
                        isLeft: false,
                        currentMonth: _currentMonthRight,
                        onMonthChanged: (newMonth) {
                          setState(() {
                            _currentMonthRight = newMonth;
                            if (!_currentMonthLeft
                                .isBefore(_currentMonthRight)) {
                              _currentMonthLeft = DateTime(
                                  newMonth.year, newMonth.month - 1);
                            }
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCalendarPane(
                          isLeft: true,
                          currentMonth: _currentMonthLeft,
                          onMonthChanged: (newMonth) {
                            setState(() {
                              _currentMonthLeft = newMonth;
                              if (!_currentMonthRight
                                  .isAfter(_currentMonthLeft)) {
                                _currentMonthRight = DateTime(
                                    newMonth.year, newMonth.month + 1);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: _buildCalendarPane(
                          isLeft: false,
                          currentMonth: _currentMonthRight,
                          onMonthChanged: (newMonth) {
                            setState(() {
                              _currentMonthRight = newMonth;
                              if (!_currentMonthLeft
                                  .isBefore(_currentMonthRight)) {
                                _currentMonthLeft = DateTime(
                                    newMonth.year, newMonth.month - 1);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_startDate != null) {
                      Navigator.pop(
                        context,
                        DateTimeRange(
                            start: _startDate!,
                            end: _endDate ?? _startDate!),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarPane({
    required bool isLeft,
    required DateTime currentMonth,
    required ValueChanged<DateTime> onMonthChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              isLeft ? 'FROM' : 'TO',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: () => onMonthChanged(
                  DateTime(currentMonth.year, currentMonth.month - 1)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('MMMM yyyy').format(currentMonth),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 24),
              onPressed: () => onMonthChanged(
                  DateTime(currentMonth.year, currentMonth.month + 1)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        _buildDaysGrid(currentMonth),
      ],
    );
  }

  Widget _buildDaysGrid(DateTime currentMonth) {
    final daysInMonth =
        DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final dayWidgets = <Widget>[];

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      final date =
          DateTime(currentMonth.year, currentMonth.month, i);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      childAspectRatio: 1.2,
      mainAxisSpacing: 4,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    bool isSelected = false;
    bool isStart = false;
    bool isEnd = false;
    bool isInRange = false;

    if (_startDate != null && DateUtils.isSameDay(date, _startDate)) {
      isSelected = true;
      isStart = true;
    }
    if (_endDate != null && DateUtils.isSameDay(date, _endDate)) {
      isSelected = true;
      isEnd = true;
    }
    if (_startDate != null && _endDate != null) {
      if (date.isAfter(_startDate!) && date.isBefore(_endDate!)) {
        isInRange = true;
      }
      if (DateUtils.isSameDay(_startDate, _endDate)) {
        isStart = true;
        isEnd = true;
      }
    }

    return GestureDetector(
      onTap: () => _onDayTapped(date),
      child: Container(
        decoration: BoxDecoration(
          color: isInRange ? _primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isStart ? const Radius.circular(4) : Radius.zero,
            right: isEnd ? const Radius.circular(4) : Radius.zero,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? _primary : Colors.transparent,
            borderRadius:
                isSelected ? BorderRadius.circular(4) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? Colors.white
                  : isInRange
                      ? _primary
                      : Colors.black87,
              fontWeight: isSelected || isInRange
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
