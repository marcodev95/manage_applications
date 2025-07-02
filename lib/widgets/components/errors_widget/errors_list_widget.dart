import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/widgets/components/errors_widget/errors_notifier.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class ErrorsListWidget extends ConsumerWidget {
  const ErrorsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errors = ref.watch(errorsProvider);

    return ListView.separated(
      itemBuilder: (_, int index) {
        final error = errors[index];

        return Column(
          children: [
            ListTile(
              title: Text(
                error.message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Data: ${uiFormat.format(error.errorDate)}',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              tileColor: Colors.grey.shade900,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: IconButton(
                onPressed: () {
                  ref.read(errorsProvider.notifier).deleteFailure(error);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppStyle.pad24),
              child: _ExpansionPanelListWidget(error),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade800),
      padding: const EdgeInsets.symmetric(vertical: AppStyle.pad8),
      itemCount: errors.length,
    );
  }
}

class _ExpansionPanelListWidget extends StatefulWidget {
  const _ExpansionPanelListWidget(this.errors);

  final Failure errors;

  @override
  State<_ExpansionPanelListWidget> createState() =>
      __ExpansionPanelListWidgetState();
}

class __ExpansionPanelListWidgetState extends State<_ExpansionPanelListWidget> {
  final isExpandedList = [false, false];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      dividerColor: Colors.black,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() => isExpandedList[index] = isExpanded);
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (_, __) {
            return ListTile(
              tileColor: Colors.grey.shade800,
              title: const Text(
                'Errore',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              '${widget.errors.error}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
            ),
          ),
          isExpanded: isExpandedList[0],
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (_, __) {
            return ListTile(
              tileColor: Colors.grey.shade800,
              title: const Text(
                'StackTrace',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          },
          body: SizedBox(
            height: 300.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                '${widget.errors.stackTrace}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          isExpanded: isExpandedList[1],
        ),
      ],
    );
  }
}
