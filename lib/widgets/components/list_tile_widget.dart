import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.title,
    this.tileColor = Colors.black54,
    this.trailing = const SizedBox(),
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 16,
    ),
    this.border = const Border(bottom: BorderSide(color: Colors.white38)),
  });

  final Color tileColor;
  final EdgeInsets contentPadding;
  final Border border;
  final Widget trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: tileColor,
      contentPadding: contentPadding,
      shape: border,
      trailing: trailing,
      title: Text(title, style: TextStyle(fontSize: 20)),
    );
  }
}
