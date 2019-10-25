import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AnimatedListModel<E> {
  AnimatedListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    if (_animatedList == null) {
      return;
    }
    items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    if (_animatedList == null) {
      return null;
    }
    final E removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(removedItem, context, animation);
      });
    }
    return removedItem;
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
