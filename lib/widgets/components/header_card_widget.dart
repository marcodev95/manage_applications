import 'package:flutter/material.dart';

//https://dribbble.com/shots/22760055-Responsive-table-design

class HeaderCardWidget extends StatelessWidget {
  const HeaderCardWidget({
    super.key,
    this.titleLabel = '',
    required this.cardBody,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.border = const Border(
      bottom: BorderSide(color: Colors.white, width: 2),
    ),
    this.fontSize = 20.0,
    this.contentTilePadding = const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
    this.tileColor = Colors.black54,
    this.trailing = const SizedBox.shrink(),
    this.elevation = 3,
    this.padding = const EdgeInsets.all(20.0),
    this.mainAxisSize = MainAxisSize.max,
  });

  final CrossAxisAlignment crossAxisAlignment;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentTilePadding;
  final EdgeInsetsGeometry padding;
  final ShapeBorder? border;
  final String titleLabel;
  final double fontSize;
  final Widget cardBody;
  final Widget trailing;
  final double elevation;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: elevation,
      child: Column(
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ListTile(
            contentPadding: contentTilePadding,
            shape: Border(
              bottom: BorderSide(color: Colors.grey[600]!, width: 2),
            ),
            trailing: trailing,
            title: Text(titleLabel, style: TextStyle(fontSize: fontSize)),
          ),

          cardBody,
        ],
      ),
    );
  }
}
