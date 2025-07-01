import 'package:manage_applications/app_style.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    super.key,
    required this.title,
    this.trailing = const SizedBox.shrink(),
    required this.body,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.externalPadding = const EdgeInsets.all(AppStyle.pad24),
  });

  final String title;
  final Widget trailing;
  final Widget body;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry externalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: externalPadding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          SectionTitle(title, trailing: trailing),
          const Divider(thickness: 1),
          AppCard(
            externalPadding: EdgeInsets.symmetric(vertical: AppStyle.pad16),
            child: body,
          ),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.externalPadding = const EdgeInsets.all(AppStyle.pad24),
    this.internalPadding = const EdgeInsets.all(AppStyle.pad16),
  });

  final Widget child;
  final EdgeInsets externalPadding;
  final EdgeInsets internalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: externalPadding,
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white24),
        ),
        child: Padding(padding: internalPadding, child: child),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget { //SectionHeader
  const SectionTitle(
    this.title, {
    super.key,
    this.trailing = const SizedBox.shrink(),
    this.externalPadding = const EdgeInsets.symmetric(vertical: AppStyle.pad16)
  });

  final String title;
  final Widget trailing;
  final EdgeInsetsGeometry externalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: externalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
