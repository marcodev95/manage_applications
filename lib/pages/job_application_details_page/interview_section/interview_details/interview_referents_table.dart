import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/widgets/components/table_widget.dart';
import 'package:manage_applications/widgets/data_load_error_screen_widget.dart';

class InterviewReferentsTable<T> extends ConsumerWidget {
  const InterviewReferentsTable({
    super.key,
    required this.allReferents,
    required this.columns,
    required this.dataCellBuilder,
    required this.invalidate,
    this.showCheckbox = false,
    this.selected,
    this.onSelectChanged,
    this.onSelectAll,
  });

  final AsyncValue<List<T>> allReferents;
  final List<DataColumn> columns;
  final List<DataCell> Function(T item, WidgetRef ref) dataCellBuilder;
  final VoidCallback invalidate;
  final bool showCheckbox;
  final bool Function(T)? selected;
  final void Function(bool?, T)? onSelectChanged;
  final void Function(bool?)? onSelectAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return allReferents.when(
      skipError: true,
      skipLoadingOnReload: true,
      data:
          (data) => TableWidget(
            showCheckboxColumn: showCheckbox,
            onSelectAll: onSelectAll,
            columns: columns,
            dataRow: buildSelectableRow(
              selected: selected,
              list: data,
              cells: (item, _) => dataCellBuilder(item, ref),
              onSelectChanged: onSelectChanged
            ),
          ),
      error: (_, __) => DataLoadErrorScreenWidget(onPressed: invalidate),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
