import 'package:flutter/material.dart';

class SideNavigationRailWidget extends StatefulWidget {
  const SideNavigationRailWidget({
    super.key,
    required this.pages,
    required this.destinations,
    this.extended = false,
    this.labelType = NavigationRailLabelType.all,
  });

  final List<Widget> pages;
  final List<NavigationRailDestination> destinations;
  final bool extended;
  final NavigationRailLabelType labelType;

  @override
  State<SideNavigationRailWidget> createState() =>
      _SideNavigationRailWidgetState();
}

class _SideNavigationRailWidgetState extends State<SideNavigationRailWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      NavigationRail(
        extended: widget.extended,
        labelType: widget.labelType,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) =>
            setState(() => selectedIndex = index),
        destinations: widget.destinations,
      ),
      const VerticalDivider(thickness: 2, width: 5, color: Colors.amber),
      Expanded(
          child: IndexedStack(
        index: selectedIndex,
        children: widget.pages,
      )),
    ]);
  }
}
