import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'vasx_colors.dart';

// ─────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────

/// A single event to display on the [CrmCalendar].
///
/// Supply [date] and optionally [time], [stage], [notes], and [id].
/// The colour is resolved automatically from [stage] via
/// [CrmStageColors.forStage] — or you may override it with [customColor].
///
/// Example:
/// ```dart
/// CrmCalendarEvent(
///   id: '1',
///   name: 'Rahul Sharma',
///   date: DateTime(2026, 7, 15),
///   time: '10:30 AM',
///   stage: 'Visit Scheduled',
/// )
/// ```
class CrmCalendarEvent {
  /// Unique identifier used by callbacks (e.g. [CrmCalendar.onEventEdit]).
  final String? id;

  /// Student / lead name shown in the event pill.
  final String name;

  /// Date of the event.
  final DateTime date;

  /// Optional time string shown in the event pill (e.g. `'10:30 AM'`).
  final String? time;

  /// Admission pipeline stage. Drives automatic colour selection.
  final String? stage;

  /// Arbitrary notes shown in the day-view detail card.
  final String? notes;

  /// Any extra payload you need to pass through (e.g. your lead model).
  final dynamic extra;

  /// Override the automatic stage colour.
  final Color? customColor;

  /// Creates a [CrmCalendarEvent].
  const CrmCalendarEvent({
    this.id,
    required this.name,
    required this.date,
    this.time,
    this.stage,
    this.notes,
    this.extra,
    this.customColor,
  });
}

/// Resolves three colours (border, background, text) for a given CRM stage.
///
/// All 12 built-in admission stages are supported. Unknown stages fall back to
/// a neutral grey palette.
class CrmStageColors {
  CrmStageColors._();

  /// Returns `{color, bg, textColor}` for [stage].
  static Map<String, Color> forStage(String? stage) {
    switch (stage) {
      case 'New Lead':
        return {
          'color': const Color(0xFF2F80ED),
          'bg': const Color(0xFFEBF3FF),
          'textColor': const Color(0xFF1E5BB0),
        };
      case 'Contacted':
        return {
          'color': const Color(0xFF2D9CDB),
          'bg': const Color(0xFFEAF7FC),
          'textColor': const Color(0xFF1F7FB3),
        };
      case 'Follow-up Required':
        return {
          'color': const Color(0xFF56CCF2),
          'bg': const Color(0xFFE6F9FF),
          'textColor': const Color(0xFF1B7FA6),
        };
      case 'Interested':
        return {
          'color': const Color(0xFF27AE60),
          'bg': const Color(0xFFEAF8EE),
          'textColor': const Color(0xFF1B7F43),
        };
      case 'Visit Scheduled':
        return {
          'color': const Color(0xFF9B59B6),
          'bg': const Color(0xFFF5EEF8),
          'textColor': const Color(0xFF763D8C),
        };
      case 'Application Started':
        return {
          'color': const Color(0xFFF2994A),
          'bg': const Color(0xFFFDF2E9),
          'textColor': const Color(0xFFB8661E),
        };
      case 'Interview Call':
        return {
          'color': const Color(0xFFE056FD),
          'bg': const Color(0xFFFDF1FF),
          'textColor': const Color(0xFF8A1FBF),
        };
      case 'Admission Offered':
        return {
          'color': const Color(0xFF219653),
          'bg': const Color(0xFFEAF8F1),
          'textColor': const Color(0xFF186F3D),
        };
      case 'Waitlisted':
        return {
          'color': const Color(0xFFF2C94C),
          'bg': const Color(0xFFFFFDF0),
          'textColor': const Color(0xFFB5931E),
        };
      case 'Lost Lead':
        return {
          'color': const Color(0xFFEB5757),
          'bg': const Color(0xFFFDF2F2),
          'textColor': const Color(0xFFB52B2B),
        };
      case 'Re-engaged':
        return {
          'color': const Color(0xFF10AC84),
          'bg': const Color(0xFFE6F8F4),
          'textColor': const Color(0xFF0B755A),
        };
      case 'Cold Lead':
        return {
          'color': const Color(0xFF7F8C8D),
          'bg': const Color(0xFFF2F4F4),
          'textColor': const Color(0xFF566573),
        };
      default:
        return {
          'color': Colors.grey,
          'bg': Colors.grey.shade50,
          'textColor': Colors.grey.shade700,
        };
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────

/// View modes available in [CrmCalendar].
enum CrmCalendarView { day, week, month }

/// A fully self-contained CRM calendar widget with Day / Week / Month views.
///
/// **Features**
/// - Month grid with event pills (max 2 shown + "+N more" overflow)
/// - Week view — 7-row list with event chips per day
/// - Day view — detailed event cards for the selected day
/// - Responsive: split layout (calendar + sidebar) on ≥ 1100 px,
///   stacked on narrower screens, compact mobile layout on < 600 px
/// - Stage-colour legend row
/// - "Upcoming leads" sidebar panel
/// - "Activities" sidebar panel for the selected day
/// - Jump-to-date via [CrmCalendar.onPickDate] callback
///
/// Supply events via [events]. Navigation (next/prev month, Today button,
/// view switching) is handled internally. Opt-in action callbacks:
/// [onEventView] and [onEventEdit] pass the event's [CrmCalendarEvent.id].
///
/// Example:
/// ```dart
/// CrmCalendar(
///   events: _events,
///   primaryColor: VasxColors.primary,
///   onEventView: (id) => _showLeadDetail(id),
///   onEventEdit: (id) => _showEditDialog(id),
///   onPickDate: (date) async {
///     final picked = await showDatePicker(...);
///     return picked;
///   },
/// )
/// ```
class CrmCalendar extends StatefulWidget {
  /// All events to display. Pass an empty list for an empty calendar.
  final List<CrmCalendarEvent> events;

  /// Primary brand colour used for today-highlight, active tabs, progress bar.
  /// Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Called when the user taps the ⊙ (visibility) icon on an event.
  /// Receives the event's [CrmCalendarEvent.id].
  final ValueChanged<String?>? onEventView;

  /// Called when the user taps the ✎ (edit) icon on a sidebar event.
  /// Receives the event's [CrmCalendarEvent.id].
  final ValueChanged<String?>? onEventEdit;

  /// Called when the user taps the calendar-icon "jump to date" button.
  /// You may show a [showDatePicker] here and return the chosen date.
  /// If you return `null` the calendar stays on the current month.
  final Future<DateTime?> Function()? onPickDate;

  /// Whether to show the loading progress bar at the top.
  final bool isLoading;

  /// Initial view. Defaults to [CrmCalendarView.month].
  final CrmCalendarView initialView;

  /// Creates a [CrmCalendar].
  const CrmCalendar({
    super.key,
    required this.events,
    this.primaryColor,
    this.onEventView,
    this.onEventEdit,
    this.onPickDate,
    this.isLoading = false,
    this.initialView = CrmCalendarView.month,
  });

  @override
  State<CrmCalendar> createState() => _CrmCalendarState();
}

class _CrmCalendarState extends State<CrmCalendar> {
  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late CrmCalendarView _view;
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  List<List<DateTime>> _grid = [];
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  Color get _primary => widget.primaryColor ?? VasxColors.primary;

  @override
  void initState() {
    super.initState();
    _view = widget.initialView;
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedDate = now;
    _buildGrid();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ─────────────── Grid ───────────────

  void _buildGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startOffset = firstDay.weekday - 1; // Mon = 0
    final start = firstDay.subtract(Duration(days: startOffset));
    final List<List<DateTime>> rows = [];
    DateTime cursor = start;
    for (int r = 0; r < 6; r++) {
      final List<DateTime> week = [];
      for (int c = 0; c < 7; c++) {
        week.add(cursor);
        cursor = cursor.add(const Duration(days: 1));
      }
      rows.add(week);
    }
    _grid = rows;
  }

  // ─────────────── Events lookup ───────────────

  List<CrmCalendarEvent> _eventsFor(DateTime date) {
    return widget.events.where((e) {
      final same = e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
      if (!same) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return e.name.toLowerCase().contains(q) ||
          (e.stage?.toLowerCase().contains(q) ?? false) ||
          (e.notes?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  List<CrmCalendarEvent> get _upcoming {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return widget.events
        .where((e) {
          final d = DateTime(e.date.year, e.date.month, e.date.day);
          return !d.isBefore(today);
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ─────────────── Navigation ───────────────

  void _prev() => setState(() {
        if (_view == CrmCalendarView.month) {
          _currentMonth =
              DateTime(_currentMonth.year, _currentMonth.month - 1);
        } else if (_view == CrmCalendarView.week) {
          _selectedDate =
              _selectedDate.subtract(const Duration(days: 7));
          _currentMonth =
              DateTime(_selectedDate.year, _selectedDate.month);
        } else {
          _selectedDate =
              _selectedDate.subtract(const Duration(days: 1));
          _currentMonth =
              DateTime(_selectedDate.year, _selectedDate.month);
        }
        _buildGrid();
      });

  void _next() => setState(() {
        if (_view == CrmCalendarView.month) {
          _currentMonth =
              DateTime(_currentMonth.year, _currentMonth.month + 1);
        } else if (_view == CrmCalendarView.week) {
          _selectedDate = _selectedDate.add(const Duration(days: 7));
          _currentMonth =
              DateTime(_selectedDate.year, _selectedDate.month);
        } else {
          _selectedDate = _selectedDate.add(const Duration(days: 1));
          _currentMonth =
              DateTime(_selectedDate.year, _selectedDate.month);
        }
        _buildGrid();
      });

  void _goToday() => setState(() {
        final now = DateTime.now();
        _currentMonth = DateTime(now.year, now.month);
        _selectedDate = now;
        _buildGrid();
      });

  // ─────────────── Build ───────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final showSplit = constraints.maxWidth >= 1100;

      return SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToolbar(isMobile),
            if (widget.isLoading) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                color: _primary,
                backgroundColor:
                    _primary.withValues(alpha: 0.1),
              ),
            ],
            const SizedBox(height: 20),
            _buildSubHeader(isMobile),
            const SizedBox(height: 16),
            if (showSplit)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 11,
                      child: _buildMainPanel(isMobile, constraints)),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: _buildSidebar()),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMainPanel(isMobile, constraints),
                  const SizedBox(height: 24),
                  _buildSidebar(),
                ],
              ),
          ],
        ),
      );
    });
  }

  // ─────────────── Toolbar ───────────────

  Widget _buildToolbar(bool isMobile) {
    final nav = _NavRow(
      onToday: _goToday,
      onPrev: _prev,
      onNext: _next,
      primary: _primary,
    );
    final viewSwitcher = _ViewSwitcher(
      current: _view,
      onChanged: (v) => setState(() => _view = v),
      primary: _primary,
    );
    final pickBtn = _IconBtn(
      icon: Icons.calendar_today_outlined,
      onTap: () async {
        final picked = await widget.onPickDate?.call();
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            _currentMonth = DateTime(picked.year, picked.month);
            _buildGrid();
          });
        }
      },
      primary: _primary,
    );
    final search = _SearchBar(
      controller: _searchCtrl,
      query: _searchQuery,
      isMobile: isMobile,
      onChanged: (q) => setState(() => _searchQuery = q),
      onClear: () => setState(() {
        _searchCtrl.clear();
        _searchQuery = '';
      }),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          search,
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [nav, Row(mainAxisSize: MainAxisSize.min, children: [viewSwitcher, const SizedBox(width: 8), pickBtn])],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: Row(children: [nav, const SizedBox(width: 12), search])),
        const SizedBox(width: 12),
        viewSwitcher,
        const SizedBox(width: 8),
        pickBtn,
      ],
    );
  }

  Widget _buildSubHeader(bool isMobile) {
    final title = _view == CrmCalendarView.month
        ? DateFormat('MMMM yyyy').format(_currentMonth)
        : _view == CrmCalendarView.day
            ? 'Day View — ${DateFormat('MMMM d, yyyy').format(_selectedDate)}'
            : 'Week View — ${DateFormat('MMMM yyyy').format(_currentMonth)}';

    final legend = _LegendRow(isMobile: isMobile);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 8),
          legend,
        ],
      );
    }

    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
        const Spacer(),
        legend,
      ],
    );
  }

  // ─────────────── Main panel ───────────────

  Widget _buildMainPanel(bool isMobile, BoxConstraints outer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      padding: const EdgeInsets.all(20),
      child: _view == CrmCalendarView.month
          ? _buildMonthGrid(isMobile)
          : _view == CrmCalendarView.day
              ? _buildDayView()
              : _buildWeekView(),
    );
  }

  // ─────────────── Month view ───────────────

  Widget _buildMonthGrid(bool isMobile) {
    return Column(
      children: [
        Row(
          children: _weekDays
              .map((d) => Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(d,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade500)),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const Divider(height: 1, color: VasxColors.borderLight),
        ..._grid.asMap().entries.map((rowEntry) {
          final rowIdx = rowEntry.key;
          final week = rowEntry.value;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: week.asMap().entries.map((colEntry) {
                final colIdx = colEntry.key;
                final date = colEntry.value;
                final inMonth = date.month == _currentMonth.month;
                final isToday = _isSameDay(date, DateTime.now());
                final isSelected = _isSameDay(date, _selectedDate);
                final events = _eventsFor(date);

                List<CrmCalendarEvent> visible = [];
                int extra = 0;
                if (events.length > 2) {
                  visible = events.sublist(0, 2);
                  extra = events.length - 2;
                } else {
                  visible = events;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      constraints: BoxConstraints(minHeight: isMobile ? 80 : 115),
                      decoration: BoxDecoration(
                        color: isToday
                            ? _primary.withValues(alpha: 0.02)
                            : isSelected
                                ? _primary.withValues(alpha: 0.01)
                                : Colors.transparent,
                        border: Border(
                          left: colIdx == 0
                              ? BorderSide.none
                              : BorderSide(color: Colors.grey.shade100),
                          top: BorderSide(color: Colors.grey.shade100),
                          bottom: rowIdx == _grid.length - 1
                              ? BorderSide(color: Colors.grey.shade100)
                              : BorderSide.none,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DayNumber(
                            day: date.day,
                            isToday: isToday,
                            isSelected: isSelected,
                            inMonth: inMonth,
                            primary: _primary,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...visible.map((ev) {
                                  final cols = _colorFor(ev);
                                  if (isMobile) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        margin: const EdgeInsets.only(bottom: 4, left: 4),
                                        decoration: BoxDecoration(color: cols['color'], shape: BoxShape.circle),
                                      ),
                                    );
                                  }
                                  return _EventPill(event: ev, colors: cols, onView: widget.onEventView);
                                }),
                                if (extra > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, top: 4),
                                    child: Text(
                                      '+ $extra more',
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  // ─────────────── Day view ───────────────

  Widget _buildDayView() {
    final events = _eventsFor(_selectedDate);
    if (events.isEmpty) {
      return _EmptySlot(label: 'No events scheduled for this day');
    }

    return Column(
      children: events.map((ev) {
        final cols = _colorFor(ev);
        final color = cols['color']!;
        final bg = cols['bg']!;
        final textColor = cols['textColor']!;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Text(ev.time ?? 'All Day',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ev.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                    const SizedBox(height: 6),
                    if (ev.stage != null)
                      Text(ev.stage!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    if (ev.notes != null && ev.notes!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(ev.notes!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                    ],
                  ],
                ),
              ),
              if (ev.id != null)
                IconButton(
                  icon: Icon(Icons.visibility_outlined,
                      color: textColor.withValues(alpha: 0.7), size: 18),
                  onPressed: () => widget.onEventView?.call(ev.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────── Week view ───────────────

  Widget _buildWeekView() {
    final startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final days = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return Column(
      children: days.map((day) {
        final events = _eventsFor(day);
        final isToday = _isSameDay(day, DateTime.now());
        final isSelected = _isSameDay(day, _selectedDate);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? _primary.withValues(alpha: 0.01)
                : isToday
                    ? Colors.grey.shade50
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? _primary.withValues(alpha: 0.15)
                  : isToday
                      ? Colors.grey.shade200
                      : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedDate = day),
                child: Container(
                  width: 46,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _primary
                        : isToday
                            ? _primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? _primary : Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(_weekDays[day.weekday - 1],
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.grey.shade500)),
                      const SizedBox(height: 4),
                      Text(day.day.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : VasxColors.textPrimary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: events.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('No events scheduled',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade400, fontStyle: FontStyle.italic)),
                      )
                    : Column(
                        children: events.map((ev) {
                          final cols = _colorFor(ev);
                          final color = cols['color']!;
                          final bg = cols['bg']!;
                          final textColor = cols['textColor']!;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: color.withValues(alpha: 0.08)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                Text(ev.time ?? 'All Day',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(ev.name,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
                                      overflow: TextOverflow.ellipsis),
                                ),
                                if (ev.id != null)
                                  InkWell(
                                    onTap: () => widget.onEventView?.call(ev.id),
                                    child: Icon(Icons.visibility_outlined,
                                        size: 13, color: textColor.withValues(alpha: 0.7)),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─────────────── Sidebar ───────────────

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UpcomingLeadsPanel(
          upcoming: _upcoming.take(4).toList(),
          onEdit: widget.onEventEdit,
          onView: widget.onEventView,
          primary: _primary,
        ),
        const SizedBox(height: 24),
        _ActivitiesPanel(
          events: _eventsFor(_selectedDate),
          date: _selectedDate,
        ),
      ],
    );
  }

  // ─────────────── Helpers ───────────────

  Map<String, Color> _colorFor(CrmCalendarEvent ev) {
    if (ev.customColor != null) {
      return {
        'color': ev.customColor!,
        'bg': ev.customColor!.withValues(alpha: 0.1),
        'textColor': ev.customColor!,
      };
    }
    return CrmStageColors.forStage(ev.stage);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ─────────────────────────────────────────────────────────────
// Small sub-widgets (private helpers)
// ─────────────────────────────────────────────────────────────

class _NavRow extends StatelessWidget {
  final VoidCallback onToday;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Color primary;

  const _NavRow({
    required this.onToday,
    required this.onPrev,
    required this.onNext,
    required this.primary,
  });

  Widget _iconBox(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: VasxColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Icon(icon, size: 18, color: Colors.grey.shade700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 38,
          child: OutlinedButton(
            onPressed: onToday,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: VasxColors.textPrimary,
              side: const BorderSide(color: VasxColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Today', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 8),
        _iconBox(Icons.chevron_left, onPrev),
        const SizedBox(width: 8),
        _iconBox(Icons.chevron_right, onNext),
      ],
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  final CrmCalendarView current;
  final ValueChanged<CrmCalendarView> onChanged;
  final Color primary;

  const _ViewSwitcher({required this.current, required this.onChanged, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VasxColors.borderLight),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tab('Day', CrmCalendarView.day),
          _tab('Week', CrmCalendarView.week),
          _tab('Month', CrmCalendarView.month),
        ],
      ),
    );
  }

  Widget _tab(String label, CrmCalendarView view) {
    final isActive = current == view;
    return GestureDetector(
      onTap: () => onChanged(view),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey.shade600)),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color primary;

  const _IconBtn({required this.icon, required this.onTap, required this.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: VasxColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Icon(icon, size: 18, color: Colors.grey.shade700)),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final bool isMobile;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.query,
    required this.isMobile,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile ? double.infinity : 260,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VasxColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search student or stage...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade400),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: Icon(Icons.clear, size: 16, color: Colors.grey.shade600),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final bool isMobile;

  static const _legends = [
    {'label': 'New Lead', 'color': Color(0xFF2F80ED)},
    {'label': 'Contacted', 'color': Color(0xFF2D9CDB)},
    {'label': 'Follow-up Required', 'color': Color(0xFF56CCF2)},
    {'label': 'Interested', 'color': Color(0xFF27AE60)},
    {'label': 'Visit Scheduled', 'color': Color(0xFF9B59B6)},
    {'label': 'Application Started', 'color': Color(0xFFF2994A)},
    {'label': 'Interview Call', 'color': Color(0xFFE056FD)},
    {'label': 'Admission Offered', 'color': Color(0xFF219653)},
    {'label': 'Waitlisted', 'color': Color(0xFFF2C94C)},
    {'label': 'Lost Lead', 'color': Color(0xFFEB5757)},
    {'label': 'Re-engaged', 'color': Color(0xFF10AC84)},
    {'label': 'Cold Lead', 'color': Color(0xFF7F8C8D)},
  ];

  const _LegendRow({required this.isMobile});

  Widget _item(Map<String, Object> leg) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: leg['color'] as Color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(leg['label'] as String,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _legends
              .map((l) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _item(l),
                  ))
              .toList(),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: _legends.map((l) => _item(l)).toList(),
    );
  }
}

class _DayNumber extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool inMonth;
  final Color primary;

  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.inMonth,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: isToday
                ? primary
                : isSelected
                    ? primary.withValues(alpha: 0.12)
                    : Colors.transparent,
            shape: BoxShape.circle,
            border: isSelected && !isToday ? Border.all(color: primary, width: 1) : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.w500,
                color: isToday
                    ? Colors.white
                    : inMonth
                        ? (isSelected ? primary : VasxColors.textPrimary)
                        : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EventPill extends StatelessWidget {
  final CrmCalendarEvent event;
  final Map<String, Color> colors;
  final ValueChanged<String?>? onView;

  const _EventPill({required this.event, required this.colors, this.onView});

  @override
  Widget build(BuildContext context) {
    final color = colors['color']!;
    final bg = colors['bg']!;
    final textColor = colors['textColor']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.time != null)
            Text(event.time!,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(event.name,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
                    overflow: TextOverflow.ellipsis),
              ),
              if (event.id != null && onView != null)
                InkWell(
                  onTap: () => onView!(event.id),
                  child: Icon(Icons.visibility_outlined, size: 10, color: textColor.withValues(alpha: 0.8)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final String label;
  const _EmptySlot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_outlined, size: 44, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ─────────────── Sidebar panels ───────────────

class _UpcomingLeadsPanel extends StatelessWidget {
  final List<CrmCalendarEvent> upcoming;
  final ValueChanged<String?>? onEdit;
  final ValueChanged<String?>? onView;
  final Color primary;

  const _UpcomingLeadsPanel({
    required this.upcoming,
    this.onEdit,
    this.onView,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Leads',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 16),
          if (upcoming.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined, size: 32, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    Text('No upcoming leads',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                  ],
                ),
              ),
            )
          else
            ...upcoming.map((lead) {
              final cols = CrmStageColors.forStage(lead.stage);
              final color = cols['color']!;
              final bg = cols['bg']!;
              final textColor = cols['textColor']!;
              final dateStr = DateFormat('MMM d, yyyy').format(lead.date);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lead.name,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('$dateStr${lead.time != null ? ' • ${lead.time}' : ''}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
                      child: Text(lead.stage ?? 'General',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                    if (lead.id != null) ...[
                      const SizedBox(width: 8),
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(Icons.edit_outlined, color: Colors.grey.shade600, size: 16),
                          onPressed: () => onEdit!(lead.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (onView != null)
                        IconButton(
                          icon: Icon(Icons.visibility_outlined, color: Colors.grey.shade600, size: 16),
                          onPressed: () => onView!(lead.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _ActivitiesPanel extends StatelessWidget {
  final List<CrmCalendarEvent> events;
  final DateTime date;

  const _ActivitiesPanel({required this.events, required this.date});

  @override
  Widget build(BuildContext context) {
    final title = 'Activities (${DateFormat('MMM d').format(date)})';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 16),
          if (events.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.event_note, size: 36, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('No activities scheduled',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, i) {
                final ev = events[i];
                final color = CrmStageColors.forStage(ev.stage)['color']!;
                final isLast = i == events.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          if (!isLast)
                            Expanded(child: Container(width: 2, color: Colors.grey.shade200)),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ev.time ?? 'All Day',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ev.name,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                                    const SizedBox(height: 2),
                                    Text(ev.stage ?? ev.notes ?? 'Follow-up',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
