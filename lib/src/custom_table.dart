import 'package:flutter/material.dart';
import 'vasx_colors.dart';

/// Defines one column in a [CustomTable].
///
/// Example:
/// ```dart
/// CustomTableColumn(label: 'Name', flex: 2)
/// CustomTableColumn(label: 'Action', flex: 1, alignment: Alignment.center)
/// ```
class CustomTableColumn {
  /// Header label displayed at the top of this column.
  final String label;

  /// Flex weight used in [Expanded] — higher values make the column wider.
  /// Defaults to `1`.
  final int flex;

  /// Alignment of cell content within each row cell. Defaults to
  /// [Alignment.centerLeft].
  final Alignment alignment;

  /// Creates a [CustomTableColumn].
  const CustomTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });
}

/// A responsive, horizontally scrollable data table widget.
///
/// Renders a styled header row followed by body rows built by [rowBuilder].
/// When the available width is less than [minWidth], the table scrolls
/// horizontally so that content is never clipped.
///
/// The number of widgets returned by [rowBuilder] **must** equal the number
/// of [columns]; an exception is thrown otherwise.
///
/// Example:
/// ```dart
/// CustomTable(
///   columns: const [
///     CustomTableColumn(label: 'Name', flex: 2),
///     CustomTableColumn(label: 'Email'),
///     CustomTableColumn(label: 'Actions', alignment: Alignment.center),
///   ],
///   itemCount: students.length,
///   rowBuilder: (context, index) {
///     final s = students[index];
///     return [
///       Text(s.name),
///       Text(s.email),
///       IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
///     ];
///   },
/// )
/// ```
class CustomTable extends StatelessWidget {
  /// Column definitions (label, flex, alignment).
  final List<CustomTableColumn> columns;

  /// Number of data rows to render.
  final int itemCount;

  /// Builder that returns one [Widget] per column for a given row [index].
  /// The list length must match [columns.length].
  final List<Widget> Function(BuildContext context, int index) rowBuilder;

  /// Minimum width of the table in logical pixels. Defaults to `1200`.
  /// The table will scroll horizontally if the viewport is narrower.
  final double minWidth;

  /// Primary color used for header text. Falls back to [VasxColors.primary]
  /// when not provided.
  final Color? primaryColor;

  /// Creates a [CustomTable].
  const CustomTable({
    super.key,
    required this.columns,
    required this.itemCount,
    required this.rowBuilder,
    this.minWidth = 1200,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? VasxColors.primary;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: VasxColors.primaryLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth < minWidth
                  ? minWidth
                  : constraints.maxWidth,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: const BoxDecoration(
                      color: VasxColors.primarySurface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      border: Border(
                          bottom:
                              BorderSide(color: VasxColors.primaryLight)),
                    ),
                    child: Row(
                      children: columns
                          .map((col) => _buildHeaderCell(col, primary))
                          .toList(),
                    ),
                  ),

                  // Body
                  Column(
                    children: List.generate(itemCount, (index) {
                      final cells = rowBuilder(context, index);
                      if (cells.length != columns.length) {
                        throw Exception(
                            'Row $index has ${cells.length} cells but table has ${columns.length} columns');
                      }
                      return _buildRow(cells, index == itemCount - 1);
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(CustomTableColumn col, Color primary) {
    return Expanded(
      flex: col.flex,
      child: Align(
        alignment: col.alignment,
        child: Text(
          col.label,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> cells, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: VasxColors.primarySurface)),
      ),
      child: Row(
        children: List.generate(cells.length, (index) {
          final col = columns[index];
          return Expanded(
            flex: col.flex,
            child: Align(alignment: col.alignment, child: cells[index]),
          );
        }),
      ),
    );
  }
}
