import 'package:flutter/material.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/util/animated_list_model.dart';

class AnimatedChatActionList extends StatefulWidget {
  final Function(ChatAction) onActionTap;
  final List<ChatAction> actions;

  AnimatedChatActionList(this.actions, this.onActionTap);

  @override
  _AnimatedChatActionListState createState() => _AnimatedChatActionListState();
}

class _AnimatedChatActionListState extends State<AnimatedChatActionList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListModel<ChatAction> _animatedListModel;

  @override
  void initState() {
    super.initState();
    _animatedListModel = AnimatedListModel<ChatAction>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: (action, context, animation) => ChatActionChip(animation: animation, action: action, onTap: widget.onActionTap),
    );
  }

  void setActions(List<ChatAction> actions) {
    for (ChatAction action in _animatedListModel.items) {
      if (!actions.contains(action)) {
        _animatedListModel.removeAt(_animatedListModel.indexOf(action));
      }
    }

    for (ChatAction action in actions) {
      if (!actions.contains(_animatedListModel.items)) {
        _animatedListModel.insert(_animatedListModel.length, action);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      scrollDirection: Axis.horizontal,
      initialItemCount: _animatedListModel.length,
      itemBuilder: (context, index, animation) {
        return ChatActionChip(
          animation: animation,
          action: _animatedListModel[index],
          onTap: widget.onActionTap,
        );
      },
    );
  }
}

class ChatActionChip extends StatelessWidget {
  const ChatActionChip({Key key, @required this.animation, this.onTap, @required this.action})
      : assert(animation != null),
        assert(action != null),
        super(key: key);

  final Animation<double> animation;
  final Function(ChatAction) onTap;
  final ChatAction action;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ActionChip(
            label: action.label != null ? Text(action.label) : null,
            avatar: action.avatar != null ? Icon(action.avatar) : null,
            onPressed: () => onTap(action)),
      ),
    );
  }
}
