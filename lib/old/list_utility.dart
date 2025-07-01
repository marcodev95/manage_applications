import 'package:flutter/material.dart';

class ListHelper<T> {
  ListHelper({required final List<T> list}) : _list = list;

  final List<T> _list;

  List<T> addItem(T item) {
    return [..._list, item];
  }

  List<T> updateItem(T item) {
    return [
      for (final el in _list)
        if (el == item) item else el
    ];
  }

  List<T> removeItem(T item) {
    return [
      for (final el in _list)
        if (el != item) el
    ];
  }

  List<T> clearList() => [];

  List<T> get list => List<T>.unmodifiable(_list);
  int get length => _list.length;
  bool get isEmpty => _list.isEmpty;
}

class ListUtilityChangeNotifier<T> extends ChangeNotifier {
  ListUtilityChangeNotifier({required final List<T> list}) : _list = list;

  final List<T> _list;

  void addItem(T item) {
    _list.add(item);
    notifyListeners();
  }

  void removeItem(T item) {
    _list.remove(item);
    notifyListeners();
  }

  void updateItem(T item) {
    final index = _list.indexOf(item);

    if (index > -1) {
      _list[index] = item;
      notifyListeners();
    }
  }

  List<T> get list => _list;
  int get length => _list.length;
}
