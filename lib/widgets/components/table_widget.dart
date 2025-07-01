import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';

class TableWidget extends StatelessWidget {
  const TableWidget({
    super.key,
    required this.columns,
    required this.dataRow,
    this.showBottomBorder = true,
    this.dividerThickness = 2.0,
    this.dataRowMaxHeight = 70.0,
    this.showCheckboxColumn = false,
    this.onSelectAll,
  });

  final List<DataColumn> columns;
  final List<DataRow> dataRow;
  final bool showBottomBorder;
  final double dividerThickness;
  final double dataRowMaxHeight;
  final bool showCheckboxColumn;
  final void Function(bool?)? onSelectAll;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns,
      rows: dataRow,
      showBottomBorder: showBottomBorder,
      dividerThickness: dividerThickness,
      dataRowMaxHeight: dataRowMaxHeight,
      showCheckboxColumn: showCheckboxColumn,
      onSelectAll: onSelectAll,
    );
  }
}

List<DataRow> createDataRowFromList<T>({
  required List<T> list,
  required List<DataCell> Function(T) cells,
  WidgetStateProperty<Color?>? color,
}) => list.map((data) => DataRow(cells: cells(data), color: color)).toList();

List<DataRow> buildColoredRow<T>({
  required List<T> list,
  required List<DataCell> Function(T, int) cells,
}) {
  final rows = <DataRow>[];
  for (int i = 0; i < list.length; i++) {
    final item = list[i];

    rows.add(
      DataRow(
        cells: cells(item, i),
        color: WidgetStatePropertyAll<Color?>(
          i.isOdd ? Color(0xFF203040) : Colors.transparent,
        ),
      ),
    );
  }

  return rows;
}

DataColumn dataColumnWidget(String label) {
  return DataColumn(
    label: Text(label, style: TextStyle(fontSize: AppStyle.tableTitleFontSize)),
  );
}

class TableButtonsWidget extends StatelessWidget {
  const TableButtonsWidget({
    super.key,
    required this.buttons,
    this.spacing = 5.0,
    this.alignment = WrapAlignment.start,
  });

  final List<Widget> buttons;
  final double spacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: alignment, spacing: spacing, children: buttons);
  }
}

class TextOverflowEllipsisWidget extends StatelessWidget {
  const TextOverflowEllipsisWidget(
    this.label, {
    super.key,
    this.fontSize = AppStyle.tableTitleFontSize,
  });

  final String label;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
