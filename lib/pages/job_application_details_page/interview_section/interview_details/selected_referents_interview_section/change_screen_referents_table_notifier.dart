import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScreenReferentsTable { selected, selection }

final changeScreenReferentsTableProvider = StateProvider.autoDispose(
  (_) => ScreenReferentsTable.selected,
);
