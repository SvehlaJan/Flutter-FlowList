import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/util/animated_list_model.dart';

class AnimatedChatActionList extends StatefulWidget {
  final Function(ChatAction) onActionTap;
  final List<ChatAction> actions;

  AnimatedChatActionList({this.onActionTap, this.actions});

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
      removedItemBuilder: _buildRemovedItem,
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

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      action: _animatedListModel[index],
      onTap: widget.onActionTap,
    );
  }

  Widget _buildRemovedItem(
      ChatAction action, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      action: action,
      onTap: widget.onActionTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<FlowChatBloc>(context),
      builder: (BuildContext context, FlowChatState state) {
        if (state is FlowChatContent) {
          return AnimatedList(
            key: _listKey,
            scrollDirection: Axis.horizontal,
            initialItemCount: _animatedListModel.length,
            itemBuilder: _buildItem,
          );
        }
      },
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key, @required this.animation, this.onTap, @required this.action})
      : assert(animation != null),
        assert(action != null),
        super(key: key);

  final Animation<double> animation;
  final Function(ChatAction) onTap;
  final ChatAction action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: ActionChip(
            label: action.label != null ? Text(action.label) : null,
            avatar: action.avatar != null ? Icon(action.avatar) : null,
            onPressed: () {
              onTap(action);
            }),
      ),
    );
  }
}
