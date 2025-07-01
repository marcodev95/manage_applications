import 'package:flutter/material.dart';

class PopupMenuButtonWidget<T> extends StatefulWidget {
  const PopupMenuButtonWidget({
    super.key,
    required this.popupMenuEntry,
    this.popupMenuIcon = Icons.more_horiz,
    this.tooltip = "Mostra menù"
  });

  final List<PopupMenuEntry<T>> popupMenuEntry;
  final IconData popupMenuIcon;
  final String tooltip;

  @override
  State<PopupMenuButtonWidget<T>> createState() => _PopupMenuButtonWidgetState<T>();
}

class _PopupMenuButtonWidgetState<T> extends State<PopupMenuButtonWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: Icon(widget.popupMenuIcon),
      tooltip: widget.tooltip,
      itemBuilder: (_) => widget.popupMenuEntry,
    );
  }
}
