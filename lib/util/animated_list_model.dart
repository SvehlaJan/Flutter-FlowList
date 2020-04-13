import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/flow_logger.dart';
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
  final Duration _duration = Duration(milliseconds: 300);

  AnimatedListState get _animatedList => listKey.currentState;

  void setItems(List<E> newItems) {
    try {
      for (E action in List.from(items)) {
        if (!newItems.contains(action)) {
          removeAt(indexOf(action));
        }
      }
    } catch (e, stackTrace) {
      // This happens after gallery is used to pick an image
      // The items in amimated list are reset and there is no way to check it
      FlowLogger.e(e, stackTrace);
      items.clear();
    }

    for (E action in newItems) {
      if (!items.contains(action)) {
        insert(length, action);
      }
    }
  }

  void insert(int index, E item) {
    if (_animatedList == null) {
      return;
    }
    items.insert(index, item);
    _animatedList.insertItem(index, duration: _duration);
  }

  E removeAt(int index) {
    if (_animatedList == null) {
      return null;
    }
    final E removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index, (BuildContext context, Animation<double> animation) => removedItemBuilder(removedItem, context, animation), duration: _duration);
    }
    return removedItem;
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
