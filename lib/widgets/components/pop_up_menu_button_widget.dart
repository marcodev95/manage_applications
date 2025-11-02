import 'package:flutter/material.dart';

class PopupMenuButtonWidget<T> extends StatefulWidget {
  const PopupMenuButtonWidget({
    super.key,
    required this.popupMenuEntry,
    this.popupMenuIcon = Icons.more_horiz,
    this.tooltip = "Mostra menù",
    this.onSelected,
    this.onCanceled,
  });

  final List<PopupMenuEntry<T>> popupMenuEntry;
  final IconData popupMenuIcon;
  final String tooltip;
  final void Function(T)? onSelected;
  final void Function()? onCanceled;

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
      onSelected: widget.onSelected,
      onCanceled: widget.onCanceled,
    );
  }
}
