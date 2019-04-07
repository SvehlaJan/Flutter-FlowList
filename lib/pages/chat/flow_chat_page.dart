import 'dart:io';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/pages/base/stateful_page.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class FlowChatPage extends StatefulPage {
  FlowChatPage() : super();

  @override
  _FlowChatPageState createState() => _FlowChatPageState();
}

class _FlowChatPageState extends StatefulPageState<FlowChatPage> {
  final _scrollController = ScrollController();
  final FlowChatBloc _flowChatBloc = FlowChatBloc();
  final TextEditingController _inputController = new TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  final FlowRepository _flowRepository = FlowRepository.get();

  @override
  void initState() {
    super.initState();
//    _scrollController.addListener(_onScroll);
    _flowChatBloc.dispatch(AppStarted());
    _focusNode.addListener(_onFocusChange);
    showContent();
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
  Widget getContentView() {
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
        color: Theme.of(context).cardColor,
        child: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: enabled ? () => _getImage(ImageSource.gallery) : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.image,
                      color: enabled
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor),
                ),
              ),
              Flexible(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context).textTheme.body1,
                  controller: _inputController,
                  autofocus: false,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    border: InputBorder.none,
                    hintText: 'Type your message...',
                    hintStyle: Theme.of(context).textTheme.body1,
                  ),
                  focusNode: _focusNode,
                ),
              ),
              InkWell(
                onTap: enabled
                    ? () => _onSendMessage(_inputController.text)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.send,
                      color: enabled
                          ? Theme.of(context).accentColor
                          : Theme.of(context).disabledColor),
                ),
//                  onPressed: enabled
//                      ? () => _onSendMessage(_inputController.text)
//                      : null,
              ),
            ],
          ),
        ));
  }

  void _onSendMessage(String text, [MessageType type = MessageType.TEXT]) {
    _inputController.clear();
    _flowChatBloc.dispatch(MessageText(body: text, type: type));
  }

  Future<void> _getImage(ImageSource source) async {
    showProgress();
    File imageFile = await ImagePicker.pickImage(
        source: source,
        maxHeight: Constants.uploadImageMaxSize,
        maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    }
    showContent();
  }

  Future<void> uploadFile(File imageFile) async {
    _flowRepository.uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _onSendMessage(downloadUrl, MessageType.IMAGE);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool fromUser =
        message != null && message.messageSender == MessageSender.USER;
    Widget body;
    if (message.type == MessageType.TEXT) {
      body = ListTile(
        leading: fromUser ? null : Icon(Icons.android),
        trailing: fromUser ? Icon(Icons.person) : null,
        title: Text(message.getMessageBody(),
            style: Theme.of(context).textTheme.body1,
            textAlign: fromUser ? TextAlign.end : TextAlign.start),
      );
    } else if (message.type == MessageType.IMAGE) {
      double width = 200;
      double height = 200;
      body = Container(
          child: CachedNetworkImage(
              placeholder: (context, url) => SizedBox(
                    child: CircularProgressIndicator(),
                    width: width,
                    height: height,
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl: message.body,
              width: width,
              height: height,
              fit: BoxFit.scaleDown));
    }
    return ChatBubble(message: message, child: body);
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

    final bg = fromUser
        ? Theme.of(context).cardColor
        : Theme.of(context).primaryColorLight;
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
