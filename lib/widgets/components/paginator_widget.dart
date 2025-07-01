import 'package:flutter/material.dart';
import 'package:manage_applications/app_style.dart';
import 'package:manage_applications/models/states/paginator_state.dart';

class PaginatorWidget extends StatelessWidget {
  const PaginatorWidget({
    super.key,
    required this.paginatorState,
    required this.previousPage,
    required this.nextPage,
  });

  final PaginatorState paginatorState;
  final VoidCallback previousPage;
  final VoidCallback nextPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppStyle.pad24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          IconButton(
            onPressed: paginatorState.pageNumber == 0 ? () {} : previousPage,
            icon: Icon(Icons.arrow_back),
          ),
          Text(paginatorState.pageNumberUI, style: TextStyle(fontSize: 16)),
          IconButton(
            onPressed: paginatorState.hasNextPage ? nextPage : () {},
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
