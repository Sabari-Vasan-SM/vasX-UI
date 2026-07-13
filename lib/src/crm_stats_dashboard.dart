import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'vasx_colors.dart';
import 'crm_calendar.dart'; // To reuse CrmStageColors

// ─────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────

/// Represents a single data point on the trend line chart.
class CrmTrendData {
  /// The date string, typically 'YYYY-MM-DD'.
  final String date;

  /// The count/value for this date.
  final double value;

  const CrmTrendData({required this.date, required this.value});
}

// ─────────────────────────────────────────────────────────────
// Main Dashboard Widget
// ─────────────────────────────────────────────────────────────

/// A complete CRM statistics dashboard UI.
///
/// **Features**
/// - Top stat cards for each stage
/// - Application Status donut chart
/// - Admission Funnel chart (custom painted)
/// - Enquiries Overview line chart using `fl_chart`
/// - Archived leads summary card
/// - Recent Logs & Reminders card
/// - Responsive grid layout (stacks on mobile)
///
/// Example:
/// ```dart
/// CrmStatsDashboard(
///   totalLeads: 150,
///   archivedLeadsCount: 12,
///   leadsByStage: {'New Lead': 50, 'Contacted': 20, ...},
///   trendData: [CrmTrendData(date: '2026-06-01', value: 5), ...],
///   startDate: DateTime(2026, 6, 1),
///   endDate: DateTime(2026, 6, 30),
///   onDateRangeTap: () => _pickDateRange(),
///   onViewArchived: () => context.push('/archived'),
///   onViewAllApplications: () => context.push('/applications'),
///   onViewLogs: () => _showLogsDialog(),
/// )
/// ```
class CrmStatsDashboard extends StatelessWidget {
  /// Total number of leads in the system.
  final int totalLeads;

  /// Number of archived leads.
  final int archivedLeadsCount;

  /// Map of stage names to their respective counts.
  /// Used for top cards, funnel, and donut chart.
  final Map<String, int> leadsByStage;

  /// Data points for the line chart.
  final List<CrmTrendData> trendData;

  /// Optional start date for the date filter display.
  final DateTime? startDate;

  /// Optional end date for the date filter display.
  final DateTime? endDate;

  /// Primary brand color. Defaults to [VasxColors.primary].
  final Color? primaryColor;

  /// Called when the date range filter button is tapped.
  final VoidCallback? onDateRangeTap;

  /// Called when the "Archived Leads" card is tapped.
  final VoidCallback? onViewArchived;

  /// Called when "View All Applications" is tapped in the donut chart card.
  final VoidCallback? onViewAllApplications;

  /// Called when "View Logs" is tapped.
  final VoidCallback? onViewLogs;

  /// Whether the dashboard is currently in a loading state.
  final bool isLoading;

  /// Optional error message to display instead of the dashboard content.
  final String? errorMessage;

  const CrmStatsDashboard({
    super.key,
    required this.totalLeads,
    required this.archivedLeadsCount,
    required this.leadsByStage,
    required this.trendData,
    this.startDate,
    this.endDate,
    this.primaryColor,
    this.onDateRangeTap,
    this.onViewArchived,
    this.onViewAllApplications,
    this.onViewLogs,
    this.isLoading = false,
    this.errorMessage,
  });

  Color get _primary => primaryColor ?? VasxColors.primary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(isMobile),
              const SizedBox(height: 24),
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: _primary),
                  ),
                )
              else if (errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(errorMessage!, style: const TextStyle(color: VasxColors.error)),
                  ),
                )
              else
                ...[
                  _TopCards(leadsByStage: leadsByStage, isMobile: isMobile),
                  const SizedBox(height: 24),
                  if (isMobile) ...[
                    _DonutChartCard(
                      totalLeads: totalLeads,
                      leadsByStage: leadsByStage,
                      onViewAll: onViewAllApplications,
                    ),
                    const SizedBox(height: 24),
                    _ArchiveCard(count: archivedLeadsCount, onTap: onViewArchived),
                    const SizedBox(height: 24),
                    _FunnelCard(leadsByStage: leadsByStage),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _DonutChartCard(
                                totalLeads: totalLeads,
                                leadsByStage: leadsByStage,
                                onViewAll: onViewAllApplications,
                              ),
                              const SizedBox(height: 24),
                              _ArchiveCard(count: archivedLeadsCount, onTap: onViewArchived),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(child: _FunnelCard(leadsByStage: leadsByStage)),
                      ],
                    )
                  ],
                  const SizedBox(height: 24),
                  _LineChartCard(trendData: trendData, primaryColor: _primary),
                  const SizedBox(height: 24),
                  _LogsCard(onTap: onViewLogs, primaryColor: _primary),
                ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    final datePickerWidget = InkWell(
      onTap: onDateRangeTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: VasxColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              startDate != null && endDate != null
                  ? '${DateFormat('MMM d, yyyy').format(startDate!)} - ${DateFormat('MMM d, yyyy').format(endDate!)}'
                  : 'All Time (Filter by Date)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 16),
          datePickerWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Dashboard Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
        datePickerWidget,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sub-components
// ─────────────────────────────────────────────────────────────

class _TopCards extends StatelessWidget {
  final Map<String, int> leadsByStage;
  final bool isMobile;

  const _TopCards({required this.leadsByStage, required this.isMobile});

  static const _allStages = [
    'New Lead', 'Contacted', 'Follow-up Required', 'Interested',
    'Visit Scheduled', 'Application Started', 'Interview Call',
    'Admission Offered', 'Waitlisted', 'Lost Lead', 'Re-engaged', 'Cold Lead'
  ];

  IconData _getIcon(String stage) {
    switch (stage) {
      case 'New Lead': return Icons.fiber_new_outlined;
      case 'Contacted': return Icons.phone_outlined;
      case 'Follow-up Required': return Icons.assignment_late_outlined;
      case 'Interested': return Icons.thumb_up_outlined;
      case 'Visit Scheduled': return Icons.event_available_outlined;
      case 'Application Started': return Icons.description_outlined;
      case 'Interview Call': return Icons.video_call_outlined;
      case 'Admission Offered': return Icons.assignment_turned_in_outlined;
      case 'Waitlisted': return Icons.hourglass_empty_outlined;
      case 'Lost Lead': return Icons.cancel_outlined;
      case 'Re-engaged': return Icons.replay_outlined;
      case 'Cold Lead': return Icons.ac_unit_outlined;
      default: return Icons.analytics_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 16.0;
        final double cardWidth = isMobile 
            ? constraints.maxWidth * 0.8 
            : (constraints.maxWidth - (5 * spacing)) / 6;

        return SizedBox(
          height: 120,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                ...ScrollConfiguration.of(context).dragDevices,
              },
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _allStages.length,
              separatorBuilder: (context, index) => const SizedBox(width: spacing),
              itemBuilder: (context, index) {
                final stage = _allStages[index];
                final count = leadsByStage[stage] ?? 0;
                final cols = CrmStageColors.forStage(stage);
                final color = cols['color']!;
                final bg = cols['bg']!;
                final icon = _getIcon(stage);

                return SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: VasxColors.borderLight),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(count.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                              const SizedBox(height: 4),
                              Text(stage, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DonutChartCard extends StatelessWidget {
  final int totalLeads;
  final Map<String, int> leadsByStage;
  final VoidCallback? onViewAll;

  const _DonutChartCard({
    required this.totalLeads,
    required this.leadsByStage,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    int total = totalLeads > 0 ? totalLeads : 1;
    
    int newLeads = leadsByStage['New Lead'] ?? 0;
    int docsPending = leadsByStage['Contacted'] ?? 0;
    int underReview = leadsByStage['Application Started'] ?? 0;
    int shortlisted = (leadsByStage['Interview Call'] ?? 0) + (leadsByStage['Visit Scheduled'] ?? 0);
    int others = totalLeads - (newLeads + docsPending + underReview + shortlisted);
    if (others < 0) others = 0;

    final Map<String, Color> donutColors = {
      'New': const Color(0xFF2F80ED),
      'Document Pending': const Color(0xFFF2C94C),
      'Under Review': const Color(0xFF9B59B6),
      'Shortlisted': const Color(0xFF27AE60),
      'Others': Colors.grey.shade400,
    };

    final items = [
      {'label': 'New', 'val': newLeads, 'color': donutColors['New']!},
      {'label': 'Document Pending', 'val': docsPending, 'color': donutColors['Document Pending']!},
      {'label': 'Under Review', 'val': underReview, 'color': donutColors['Under Review']!},
      {'label': 'Shortlisted', 'val': shortlisted, 'color': donutColors['Shortlisted']!},
      {'label': 'Others', 'val': others, 'color': donutColors['Others']!},
    ];

    List<PieChartSectionData> sections = [];
    for (var item in items) {
      double val = (item['val'] as int).toDouble();
      sections.add(
        PieChartSectionData(
          color: item['color'] as Color,
          value: val,
          title: '',
          radius: 35,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Application Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 32),
          Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        sections: sections,
                        startDegreeOffset: -90,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            totalLeads.toString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: VasxColors.textPrimary),
                          ),
                          Text('Total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.map((item) {
                    int val = item['val'] as int;
                    int pct = ((val / total) * 100).round();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: item['color'] as Color, shape: BoxShape.circle)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(item['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: VasxColors.textPrimary))),
                          Text('$val ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          Text('($pct%)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          if (onViewAll != null)
            InkWell(
              onTap: onViewAll,
              child: const Row(
                children: [
                  Text('View All Applications ', style: TextStyle(color: Color(0xFF2F80ED), fontWeight: FontWeight.bold, fontSize: 13)),
                  Icon(Icons.arrow_forward, color: Color(0xFF2F80ED), size: 16),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _FunnelCard extends StatelessWidget {
  final Map<String, int> leadsByStage;

  const _FunnelCard({required this.leadsByStage});

  static const _stages = [
    'New Lead', 'Contacted', 'Follow-up Required', 'Interested',
    'Visit Scheduled', 'Application Started', 'Interview Call',
    'Admission Offered'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Admission Funnel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
          const SizedBox(height: 32),
          SizedBox(
            height: 360,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomPaint(
                    painter: _FunnelPainter(
                      colors: _stages.map((s) => CrmStageColors.forStage(s)['color'] ?? Colors.grey.shade300).toList(),
                    ),
                    child: Container(),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _stages.map((stage) {
                      int count = leadsByStage[stage] ?? 0;
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '$count - ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                            TextSpan(text: stage, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _FunnelPainter extends CustomPainter {
  final List<Color> colors;

  _FunnelPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;
    final double width = size.width;
    final double height = size.height;
    int layers = colors.length;
    if (layers == 0) return;

    double layerHeight = height / layers;
    double gap = 2.0;

    double topWidth = width;
    double bottomWidth = width * 0.15;
    
    for (int i = 0; i < layers; i++) {
      double yTop = i * layerHeight;
      double yBottom = (i + 1) * layerHeight - gap;
      
      double currentTopWidth = topWidth - (topWidth - bottomWidth) * (yTop / height);
      double currentBottomWidth = topWidth - (topWidth - bottomWidth) * (yBottom / height);
      
      double xTopLeft = (width - currentTopWidth) / 2;
      double xTopRight = xTopLeft + currentTopWidth;
      double xBottomLeft = (width - currentBottomWidth) / 2;
      double xBottomRight = xBottomLeft + currentBottomWidth;
      
      Path path = Path()
        ..moveTo(xTopLeft, yTop)
        ..lineTo(xTopRight, yTop)
        ..lineTo(xBottomRight, yBottom)
        ..lineTo(xBottomLeft, yBottom)
        ..close();
        
      Paint paint = Paint()
        ..color = colors[i].withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;
        
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FunnelPainter oldDelegate) => true;
}

class _ArchiveCard extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const _ArchiveCard({required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: VasxColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Archived Leads',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VasxColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: VasxColors.textPrimary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Icon(Icons.archive_outlined, color: Colors.grey.shade600, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartCard extends StatelessWidget {
  final List<CrmTrendData> trendData;
  final Color primaryColor;

  const _LineChartCard({required this.trendData, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final spots = trendData.asMap().entries.map((e) => FlSpot(e.key.toDouble() + 1, e.value.value)).toList();
    final dates = trendData.map((e) => e.date).toList();
    final maxY = spots.isEmpty ? 10.0 : (spots.map((e) => e.y).fold(0.0, (a, b) => a > b ? a : b) + 20).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VasxColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enquiries Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 280,
            child: spots.isEmpty
                ? const Center(child: Text('No trend data available'))
                : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt() - 1;
                        if (index < 0 || index >= dates.length) return const SizedBox.shrink();
                        
                        if (index == 0 || index % 5 == 0 || index == dates.length - 1) {
                          final parts = dates[index].split('-');
                          if (parts.length == 3) {
                            final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                            int m = int.tryParse(parts[1]) ?? 1;
                            String text = '${parts[2]} ${monthNames[m-1]}';
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: spots.length.toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: const Color(0xFF2F80ED),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF2F80ED),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2F80ED).withValues(alpha: 0.2),
                          const Color(0xFF2F80ED).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.white,
                    tooltipBorderRadius: BorderRadius.circular(8),
                    tooltipPadding: const EdgeInsets.all(12),
                    tooltipBorder: BorderSide(color: Colors.grey.shade200),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        String dateText = '';
                        int index = touchedSpot.x.toInt() - 1;
                        if (index >= 0 && index < dates.length) {
                          final parts = dates[index].split('-');
                          if (parts.length == 3) {
                            final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                            int m = int.tryParse(parts[1]) ?? 1;
                            dateText = '${parts[2]} ${monthNames[m-1]}, ${parts[0]}';
                          }
                        }
                        
                        return LineTooltipItem(
                          '$dateText\n',
                          const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Enquiries: ${touchedSpot.y.toInt()}',
                              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.normal, fontSize: 12),
                            )
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogsCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Color primaryColor;

  const _LogsCard({this.onTap, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VasxColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Logs & Reminders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('View a detailed history of lead stage changes and communications sent.', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('View Logs', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Logs Dialog Component
// ─────────────────────────────────────────────────────────────

/// Represents a single log entry.
class CrmLogEntry {
  final String dateStr;
  final String studentName;
  final String type;
  final String details;

  const CrmLogEntry({
    required this.dateStr,
    required this.studentName,
    required this.type,
    required this.details,
  });
}

/// A dialog showing paginated logs, matching the design of the CRM Stats page.
class CrmLogsDialog extends StatelessWidget {
  final List<CrmLogEntry> logs;
  final int totalRecords;
  final int currentPage;
  final int limit;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onLimitChanged;
  final Color? primaryColor;

  const CrmLogsDialog({
    super.key,
    required this.logs,
    required this.totalRecords,
    required this.currentPage,
    required this.limit,
    required this.onPageChanged,
    required this.onLimitChanged,
    this.isLoading = false,
    this.errorMessage,
    this.primaryColor,
  });

  Color get _primary => primaryColor ?? VasxColors.primary;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (totalRecords / limit).ceil();
    final bool hasPrev = currentPage > 1;
    final bool hasNext = currentPage < totalPages;

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 900,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Logs & Reminders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: VasxColors.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: _primary))
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!, style: const TextStyle(color: VasxColors.error)))
                      : logs.isEmpty
                          ? Center(child: Text('No logs found.', style: TextStyle(color: Colors.grey.shade500)))
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: VasxColors.borderLight),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(_primary.withValues(alpha: 0.10)),
                                    headingTextStyle: TextStyle(color: _primary, fontWeight: FontWeight.w600, fontSize: 12),
                                    columnSpacing: 24,
                                    horizontalMargin: 24,
                                    columns: const [
                                      DataColumn(label: Text('S No')),
                                      DataColumn(label: Text('Date & Time')),
                                      DataColumn(label: Text('Student')),
                                      DataColumn(label: Text('Type')),
                                      DataColumn(label: Text('Details')),
                                    ],
                                    rows: logs.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      var log = entry.value;
                                      int serialNo = (currentPage - 1) * limit + index + 1;

                                      return DataRow(cells: [
                                        DataCell(Text(serialNo.toString().padLeft(2, '0'), style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                                        DataCell(Text(log.dateStr, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor: _primary.withValues(alpha: 0.1),
                                                child: Text(
                                                  log.studentName.isNotEmpty ? log.studentName[0].toUpperCase() : '?',
                                                  style: TextStyle(fontSize: 10, color: _primary, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(log.studentName.isEmpty ? 'Unknown' : log.studentName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: (log.type == 'Stage Change') ? Colors.blue.withValues(alpha: 0.1) : Colors.purple.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              log.type,
                                              style: TextStyle(fontSize: 12, color: (log.type == 'Stage Change') ? Colors.blue.shade700 : Colors.purple.shade700, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(log.details, style: const TextStyle(fontSize: 13, color: VasxColors.textPrimary))),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
            ),
            if (!isLoading && totalRecords > 0)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Showing', style: TextStyle(color: VasxColors.textPrimary, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: VasxColors.borderLight),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: limit,
                              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: VasxColors.textPrimary),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: VasxColors.textPrimary),
                              isDense: true,
                              items: [10, 15, 20, 50].map((e) => DropdownMenuItem(value: e, child: Text('$e rows'))).toList(),
                              onChanged: (val) {
                                if (val != null) onLimitChanged(val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('out of $totalRecords', style: const TextStyle(color: VasxColors.textPrimary, fontSize: 14)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPageBox(null, icon: Icons.keyboard_double_arrow_left, enabled: hasPrev, onTap: () => onPageChanged(currentPage - 1)),
                        const SizedBox(width: 8),
                        ..._buildPageNumbers(totalPages),
                        _buildPageBox(null, icon: Icons.keyboard_double_arrow_right, enabled: hasNext, onTap: () => onPageChanged(currentPage + 1)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    List<Widget> boxes = [];
    int start = currentPage > 2 ? currentPage - 2 : 1;
    int end = start + 4 > totalPages ? totalPages : start + 4;
    
    if (end - start < 4 && totalPages >= 5) {
      start = end - 4 > 0 ? end - 4 : 1;
    }

    for (int i = start; i <= end; i++) {
      boxes.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _buildPageBox(
            i.toString(),
            isActive: i == currentPage,
            onTap: () {
              if (i != currentPage) onPageChanged(i);
            },
          ),
        ),
      );
    }
    return boxes;
  }

  Widget _buildPageBox(String? text, {IconData? icon, bool isActive = false, VoidCallback? onTap, bool enabled = true}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? _primary : Colors.white,
          border: Border.all(color: isActive ? _primary : VasxColors.borderLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(
                    color: isActive ? Colors.white : VasxColors.textPrimary,
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                )
              : Icon(icon, size: 20, color: enabled ? VasxColors.textPrimary : Colors.grey[300]),
        ),
      ),
    );
  }
}
