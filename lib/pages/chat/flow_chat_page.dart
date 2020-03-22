import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_bloc.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:flutter_flow_list/ui/chat_action_animated_list.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FlowChatPage extends StatefulWidget {
  FlowChatPage() : super();

  @override
  _FlowChatPageState createState() => _FlowChatPageState();
}

class _FlowChatPageState extends BasePageState<FlowChatPage> {
  FlowChatBloc _flowChatBloc;
  final TextEditingController _inputController = new TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  AnimatedChatActionList _chatActionList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _flowChatBloc = BlocProvider.of<FlowChatBloc>(context);
    _flowChatBloc.add(AppStarted());
    _focusNode.addListener(_onFocusChange);
  }

  void showContent() => setState(() {
        _isLoading = false;
      });

  void showLoading() => setState(() {
        _isLoading = true;
      });

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
    return 'Chat';
  }

  void _onSendMessage(String text, [MessageType type = MessageType.TEXT]) {
    _inputController.clear();
    _flowChatBloc.add(MessageText(body: text, type: type));
  }

  Future<void> _getImage(ImageSource source) async {
    showLoading();
    File imageFile = await ImagePicker.pickImage(source: source, maxHeight: Constants.uploadImageMaxSize, maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    }
    showContent();
  }

  Future<void> uploadFile(File imageFile) async {
    Provider.of<FlowRepository>(context, listen: false).uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _onSendMessage(downloadUrl, MessageType.IMAGE);
    }, onError: (err) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("This file is not an image")));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Constants.centeredProgressIndicator;
    } else {
      return buildScaffold(
          context,
          BlocBuilder(
            bloc: _flowChatBloc,
            builder: (BuildContext context, FlowChatState state) {
              if (state is FlowChatLoading) {
                return Constants.centeredProgressIndicator;
              }
              if (state is FlowChatError) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is FlowChatContent) {
                return _buildChatContent(context, state);
              }
              return Constants.centeredProgressIndicator;
            },
          ));
    }
  }

  Widget _buildChatContent(BuildContext context, FlowChatContent state) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(12.0),
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (state is FlowChatTyping && index == 0) {
              return ChatTypingWidget();
            } else {
              return ChatMessageWidget(message: state.messages[index]);
            }
          },
          itemCount: state.messages.length,
        ),
      ),
      _buildChatInput(context, state)
    ]);
  }

  void _onChatActionClicked(ChatAction action) {
    switch (action.type) {
      case ChatActionType.TEXT:
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Test")));
        break;
      case ChatActionType.SKIP:
        _onSendMessage(action.label);
        break;
      case ChatActionType.PHOTO:
        _getImage(ImageSource.camera);
        break;
      case ChatActionType.GALERY:
        _getImage(ImageSource.gallery);
        break;
    }
  }

  Widget _buildChatInput(BuildContext context, FlowChatContent state) {
    bool enabled = !(state is FlowChatTyping);
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        height: 40.0,
        child: AnimatedChatActionList(onActionTap: _onChatActionClicked, actions: state.chatActions),
//        child: ListView.builder(
//            padding: EdgeInsets.symmetric(horizontal: 8.0),
//            itemBuilder: (context, index) {
//              ChatAction action = state.chatActions[index];
//              return Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                child: ActionChip(
//                    label: action.label != null ? Text(action.label) : null,
//                    avatar: action.avatar != null ? Icon(action.avatar) : null,
//                    onPressed: () {
//                      _onChatActionClicked(action);
//                    }),
//              );
//            },
//            scrollDirection: Axis.horizontal,
//            itemCount: state.chatActions.length),
      ),
      Row(children: <Widget>[
        Flexible(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            style: Theme.of(context).textTheme.body1,
            controller: _inputController,
            autofocus: false,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              border: InputBorder.none,
              hintText: 'Type your message...',
              hintStyle: Theme.of(context).textTheme.body1,
            ),
            focusNode: _focusNode,
          ),
        ),
        InkWell(
          onTap: enabled ? () => _onSendMessage(_inputController.text) : null,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.send, color: enabled ? Theme.of(context).accentColor : Theme.of(context).disabledColor),
          ),
        ),
      ])
    ]);
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool fromUser = message != null && message.messageSender == MessageSender.USER;
    Widget body;
    if (message.type == MessageType.TEXT) {
      body = Align(
        alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(message.messageBody, style: Theme.of(context).textTheme.bodyText1),
      );
    } else if (message.type == MessageType.IMAGE) {
      body = Center(
        child: CachedNetworkImage(
          placeholder: (context, url) => Constants.centeredProgressIndicator,
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageUrl: message.body,
          fit: BoxFit.fill,
        ),
      );
    }
    return ChatBubble(message: message, child: body);
  }
}

class ChatTypingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChatBubble(message: null, child: SpinKitThreeBounce(color: Theme.of(context).textTheme.body1.color, size: 24.0));
  }
}

class ChatBubble extends Container {
  final ChatMessage message;
  final Widget child;

  ChatBubble({this.message, this.child});

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    bool fromUser = message != null && message.messageSender == MessageSender.USER;

    final bg = fromUser ? Theme.of(context).cardColor : Theme.of(context).primaryColorLight;
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

    Widget avatar;
    if (fromUser && userRepository.isLoggedIn) {
      avatar = ClipOval(
        child: CachedNetworkImage(
          width: Constants.avatarImageSize,
          height: Constants.avatarImageSize,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageUrl: userRepository.getPhotoUrl() ?? "",
          fit: BoxFit.cover,
        ),
      );
    } else {
      avatar = Container(
        width: Constants.avatarImageSize,
        height: Constants.avatarImageSize,
        child: avatar = fromUser ? Icon(Icons.person, color: Theme.of(context).primaryIconTheme.color) : Icon(Icons.android, color: Theme.of(context).primaryIconTheme.color),
        decoration: ShapeDecoration(shape: CircleBorder(), color: Theme.of(context).accentColor),
      );
    }

    return Row(
      children: <Widget>[
        fromUser ? Container(width: Constants.avatarImageSize) : avatar,
        Expanded(
          child: Container(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: Constants.chatBubbleHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child,
                  )),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: .5, spreadRadius: 1.0, color: Colors.black.withOpacity(.12))],
                color: bg,
                borderRadius: radius,
              )),
        ),
        fromUser ? avatar : Container(width: Constants.avatarImageSize),
      ],
    );
  }
}
