import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/pages/base/base_page.dart';

class FlowChatPage extends BasePage {
  FlowChatPage() : super();

  @override
  _FlowChatPageState createState() => _FlowChatPageState();
}

class _FlowChatPageState extends BasePageState<FlowChatPage> {
  final _scrollController = ScrollController();
  final FlowChatBloc _flowChatBloc = FlowChatBloc();
  final TextEditingController _inputController = new TextEditingController();
  final FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
//    _scrollController.addListener(_onScroll);
    _flowChatBloc.dispatch(AppStarted());
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _flowChatBloc.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Hide sticker when keyboard appear
//      setState(() {
//        isShowSticker = false;
//      });
    }
  }

  @override
  String getPageTitle() {
    return 'Flow notes';
  }

  @override
  Widget buildBody() {
    return BlocBuilder(
      bloc: _flowChatBloc,
      builder: (BuildContext context, FlowChatState state) {
        if (state is FlowChatLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FlowChatError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is FlowChatContent) {
          if (state.messages.isEmpty) {
            return Center(
              child: Text('No messages'),
            );
          }
//          _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          return _buildChatContent(context, state);
        }
      },
    );
  }

  Widget _buildChatContent(BuildContext context, FlowChatContent state) {
    return Column(children: <Widget>[
      Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(4.0),
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (state is FlowChatTyping && index == 0) {
              return ChatTypingWidget();
            } else {
              return ChatMessageWidget(message: state.messages[index]);
            }
          },
          itemCount: state.messages.length,
          controller: _scrollController,
        ),
      ),
      _buildChatInput(context, state)
    ]);
  }

  Widget _buildChatInput(BuildContext context, FlowChatContent state) {
    bool enabled = !(state is FlowChatTyping);
    return Material(
        elevation: 4,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  style: Theme.of(context).textTheme.body2,
                  controller: _inputController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    hintText: 'Type your message...',
                    hintStyle: Theme.of(context).textTheme.body1,
                  ),
                  focusNode: _focusNode,
                ),
              ),
              Material(
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: enabled ? () => onSendMessage(_inputController.text) : null,
                  color: Theme.of(context).primaryColor,
                ),
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  void onSendMessage(String text) {
    _inputController.clear();
    _flowChatBloc.dispatch(Message(body: text));
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool fromUser =
        message != null && message.messageSender == MessageSender.USER;
    return ChatBubble(
        message: message,
        child: ListTile(
          leading: fromUser ? null : Icon(Icons.android),
          trailing: fromUser ? Icon(Icons.person) : null,
          title: Text(message.getMessageBody(),
              textAlign: fromUser ? TextAlign.end : TextAlign.start),
        ));
  }
}

class ChatTypingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatBubble(
        message: null,
        child: ListTile(
          leading: Icon(Icons.android),
          title: Text("..."),
        ));
  }
}

class ChatBubble extends Container {
  final ChatMessage message;
  final Widget child;

  ChatBubble({this.message, this.child});

  @override
  Widget build(BuildContext context) {
    bool fromUser =
        message != null && message.messageSender == MessageSender.USER;

    final bg = fromUser ? Colors.white : Colors.blue.shade50;
    final radius = fromUser
        ? BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(15.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(10.0),
          );

    return Container(
        child: child,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: .5,
                spreadRadius: 1.0,
                color: Colors.black.withOpacity(.12))
          ],
          color: bg,
          borderRadius: radius,
        ));
  }
}
