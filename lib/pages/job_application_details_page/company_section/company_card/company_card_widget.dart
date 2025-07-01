import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/company/company.dart';
import 'package:manage_applications/widgets/components/section_widget.dart';
import 'package:manage_applications/widgets/components/utility.dart';

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.trailing,
    required this.cardLabel,
    this.company,
    this.isMain = true,
    this.externalPadding = const EdgeInsets.only(right: 24, left: 24, top: 18, bottom: 0),
  });

  final Company? company;
  final Widget trailing;
  final String cardLabel;
  final bool isMain;
  final EdgeInsets externalPadding;

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      externalPadding: externalPadding,
      title: cardLabel,
      trailing: company?.id == null ? trailing : SizedBox(),
      body: Padding(
        padding: EdgeInsets.all(AppStyle.pad8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Icon(
                  Icons.business,
                  size: 28,
                  color: isMain ? Colors.blueAccent : Colors.green,
                ),
                Text(
                  company?.name ?? 'Nessuna azienda selezionata',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 20),
            _infoRow(
              Icons.location_city,
              '${company?.address ?? '-'}, ${company?.city ?? '-'}',
            ),
            _infoRow(Icons.mail_outline, company?.email ?? '-'),
            _infoRow(Icons.phone, company?.phoneNumber ?? '-'),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed:
                    company?.id == null
                        ? () {}
                        : () => tryToLaunchUrl(
                          context: context,
                          link: company?.website ?? '',
                        ),
                icon: Icon(Icons.language),
                label: Text("Visita sito"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String data) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        spacing: 8.0,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          Flexible(child: Text(data, style: TextStyle(fontSize: 16),)),
        ],
      ),
    );
  }
}
