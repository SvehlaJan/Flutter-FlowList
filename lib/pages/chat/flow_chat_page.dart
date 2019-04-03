import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/bloc/flow_chat_state.dart';
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
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
//    _scrollController.addListener(_onScroll);
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _flowChatBloc.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
//      setState(() {
//        isShowSticker = false;
//      });
    }
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
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
            child: TextField(
              style: Theme.of(context).textTheme.body2,
              controller: _inputController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: InputBorder.none,
                hintText: 'Type your message...',
                hintStyle: Theme.of(context).textTheme.body1,
              ),
              focusNode: focusNode,
            ),
          ),
        ),

        // Button send message
        Material(
          child: new Container(
            margin: new EdgeInsets.symmetric(horizontal: 8.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => onSendMessage(_inputController.text),
              color: Theme.of(context).primaryColor,
            ),
          ),
          color: Colors.white,
        ),
      ],
    );
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
    bool fromBot = message.messageSender == MessageSender.BOT;
    bool fromUser = message.messageSender == MessageSender.USER;
    return ListTile(
      leading: fromBot ? Icon(Icons.android) : null,
      trailing: fromUser ? Icon(Icons.person) : null,
      title: Text(message.getMessageBody(),
          textAlign: fromBot ? TextAlign.start : TextAlign.end),
    );
  }
}

class ChatTypingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("..."),
    );
  }
}
