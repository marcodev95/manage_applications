import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/contract/contract.dart';
import 'package:manage_applications/models/shared/operation_result.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_details_page.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/contract_details/contract_form/contract_form_utlity.dart';
import 'package:manage_applications/pages/job_application_details_page/contract_section/provider/contract_delete_undo_provider.dart';
import 'package:manage_applications/widgets/components/button/details_button_widget.dart';
import 'package:manage_applications/widgets/components/button/remove_button_widget.dart';
import 'package:manage_applications/widgets/components/divider_widget.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';
import 'package:manage_applications/widgets/components/vertical_separator_widget.dart';

class ContractCard extends ConsumerWidget {
  const ContractCard(this.contract, {super.key});

  final ContractUI contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      externalPadding: const EdgeInsets.symmetric(vertical: AppStyle.pad16),
      child: Padding(
        padding: const EdgeInsets.all(AppStyle.pad16),
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContractTypeRow(type: contract.type.displayName),

            Row(
              children: [
                _ContractDurationRow(contract.contractDuration),
                const VerticalSeparatorWidget(),
                _ContractDateRow(
                  startDate: contract.startDate,
                  endDate: contract.endDate,
                ),
              ],
            ),

            Row(
              children: [
                if (contract.isTrialContract) ...[
                  const _TrailBadge(),
                  const VerticalSeparatorWidget(),
                ],
                _ContractRalRow(contract.ral),
              ],
            ),

            const DividerWidget(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 12.0,
              children: [
                DetailsButtonWidget(
                  onPressed:
                      () => navigatorPush(
                        context,
                        ContractDetailsPage(),
                        RouteSettings(arguments: contract.id),
                      ),
                ),
                RemoveButtonWidget(
                  onPressed: () => _onPressedDelete(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressedDelete(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(contractDeleteUndoProvider.notifier);
    final result = await controller.deleteContract(contract);

    if (!context.mounted) return;

    result.handleErrorResult(context: context, ref: ref);
  }
}

class _ContractDurationRow extends StatelessWidget {
  const _ContractDurationRow(this.duration);

  final String? duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Tooltip(
          message: 'Durata del contratto',
          child: Icon(Icons.timer, color: Colors.teal),
        ),
        Text(
          duration ?? 'Da definire',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ContractTypeRow extends StatelessWidget {
  const _ContractTypeRow({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24,
      children: [
        Row(
          spacing: 10,
          children: [
            const Tooltip(
              message: 'Tipologia di contratto',
              child: Icon(Icons.description, color: Colors.grey),
            ),
            Text(type, style: AppStyle.cardTitle),
          ],
        ),
      ],
    );
  }
}

class _TrailBadge extends StatelessWidget {
  const _TrailBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10.0,
      children: [
        Tooltip(
          message: 'Contratto per periodo di prova',
          child: Icon(Icons.star, color: Colors.orangeAccent),
        ),
        Text(
          'Periodo di prova',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ContractDateRow extends StatelessWidget {
  const _ContractDateRow({required this.startDate, required this.endDate});

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            const Tooltip(
              message: 'Periodo contrattuale',
              child: Icon(Icons.calendar_month_rounded, color: Colors.purple),
            ),
            Text(
              _buildDateValue(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _buildDateValue() {
    if (startDate == null && endDate == null) {
      return 'Da definire';
    }

    if (startDate != null && endDate == null) {
      return '${uiFormat.format(startDate!)} → Da definire';
    }

    return '${uiFormat.format(startDate!)} → ${uiFormat.format(endDate!)}';
  }
}

class _ContractRalRow extends StatelessWidget {
  const _ContractRalRow(this.ral);

  final int? ral;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const Tooltip(
          message: 'RAL',
          child: Icon(Icons.attach_money, color: Colors.green),
        ),
        Text(
          _buildRalLabel(ral),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _buildRalLabel(int? ral) {
    return ral == null ? 'Da definire' : '${getRalFormatter.format(ral)} €';
  }
}
