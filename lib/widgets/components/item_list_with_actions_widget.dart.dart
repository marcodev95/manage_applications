import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/widgets/components/button/details_button_widget.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';

class ItemListWithActionsWidget<T> extends StatelessWidget {
  const ItemListWithActionsWidget({
    super.key,
    required this.items,
    required this.itemToString,
    required this.editCallback,
    required this.deleteCallback,
  });

  final List<T> items;
  final String Function(T) itemToString;
  final ValueChanged<T> editCallback;
  final ValueChanged<T> deleteCallback;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(right: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isOdd = index.isOdd;
        final backgroundColor = isOdd ? Color(0xFF203040) : Colors.transparent;

        return ColoredBox(
          color: backgroundColor,
          child: ListTile(
            contentPadding: EdgeInsets.all(AppStyle.pad8),
            title: Text(
              (itemToString(item)),
              style: TextStyle(fontSize: AppStyle.tableTextFontSize),
            ),
            trailing: Row(
              spacing: 20.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                DetailsButtonWidget(
                  onPressed: () => editCallback(item),
                  label: 'Modifica',
                ),
                RemoveButtonWidget(onPressed: () => deleteCallback(item)),
              ],
            ),
          ),
        );
      },
    );
  }
}
