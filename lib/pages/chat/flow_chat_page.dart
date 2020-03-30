import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/pages/base/base_page_state.dart';
import 'package:flutter_flow_list/pages/chat/chat_view_model.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_state.dart';
import 'package:flutter_flow_list/ui/chat_action_animated_list.dart';
import 'package:flutter_flow_list/util/R.dart';
import 'package:flutter_flow_list/util/animated_list_model.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class FlowChatPage extends StatefulWidget {
  FlowChatPage() : super();

  @override
  _FlowChatPageState createState() => _FlowChatPageState();
}

class _FlowChatPageState extends BasePageState<FlowChatPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  AnimatedListModel<ChatAction> _chatActionList;
  final TextEditingController _inputController = TextEditingController();

  @override
  String getPageTitle() => R.string(context).chat_title;

  @override
  void initState() {
    super.initState();
    _chatActionList = AnimatedListModel<ChatAction>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: (action, context, animation) => ChatActionChip(
        animation: animation,
        action: action,
        onTap: (chatAction) => _onChatActionClicked(chatAction),
      ),
    );
  }

  void _onSendMessage(String text, ChatViewModel model, [MessageType type = MessageType.TEXT]) {
    _inputController.clear();
    model.onMessageSent(UserMessage(body: text, type: type));
  }

  void _onChatActionClicked(ChatAction action) async {
    // TODO - try to pass the model from builder
    ChatViewModel model = getIt<ChatViewModel>();

    switch (action.type) {
      case ChatActionType.GO:
        _onSendMessage(action.label, model);
        break;
      case ChatActionType.SKIP:
        _onSendMessage(action.label, model);
        break;
      case ChatActionType.PHOTO:
        model.getImage(ImageSource.camera);
        break;
      case ChatActionType.GALLERY:
        model.getImage(ImageSource.gallery);
        break;
      case ChatActionType.GIF:
        GiphyGif gif = await GiphyPicker.pickGif(context: context, apiKey: Constants.GIPHY_API_KEY);
        model.onGifSelected(gif);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChatViewModel>.withConsumer(
        viewModel: getIt<ChatViewModel>(),
        reuseExisting: true,
        onModelReady: (model) {
          model.chatActionsStream.listen((chatActions) {
            _chatActionList.setItems(chatActions);
          });

          model.startChat();
        },
        builder: (context, model, child) {
          if (model.busy) {
            return buildScaffold(context, Constants.centeredProgressIndicator);
          } else {
            return buildScaffold(context, _buildChatContent(context, model));
          }
        });
  }

  Widget _buildChatContent(BuildContext context, ChatViewModel model) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(12.0),
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (model.state is FlowChatTyping && index == 0) {
              return ChatTypingWidget(model);
            } else {
              return ChatMessageWidget(model, model.state.messageHistory[index]);
            }
          },
          itemCount: model.state.messageHistory.length,
        ),
      ),
      _buildChatInput(context, model)
    ]);
  }

  Widget _buildChatActionItem(ChatAction action, BuildContext context, Animation<double> animation) {
    return ChatActionChip(animation: animation, action: action, onTap: (chatAction) => _onChatActionClicked(chatAction));
  }

  Widget _buildChatInput(BuildContext context, ChatViewModel model) {
    bool enabled = !(model.state is FlowChatTyping);

    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Container(
          height: 40.0,
          child: AnimatedList(
            key: _listKey,
            scrollDirection: Axis.horizontal,
            initialItemCount: 0,
            itemBuilder: (context, index, animation) {
              return _buildChatActionItem(_chatActionList.items[index], context, animation);
            },
          ),
        ),
      ),
      Row(children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _inputController,
              textInputAction: TextInputAction.send,
              onSubmitted: (message) => model.onMessageSent(UserMessage(body: message)),
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                border: OutlineInputBorder(),
                hintText: R.string(context).chat_input_hint,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: enabled ? () => _onSendMessage(_inputController.text, model) : null,
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
  final ChatViewModel model;
  final ChatHistoryMessage message;

  const ChatMessageWidget(this.model, this.message);

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
    return ChatBubble(model, message, body);
  }
}

class ChatTypingWidget extends StatelessWidget {
  final ChatViewModel model;

  ChatTypingWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ChatBubble(model, null, SpinKitThreeBounce(color: Theme.of(context).textTheme.body1.color, size: 24.0));
  }
}

class ChatBubble extends Container {
  final ChatViewModel model;
  final ChatHistoryMessage message;
  final Widget child;

  ChatBubble(this.model, this.message, this.child);

  @override
  Widget build(BuildContext context) {
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
    if (fromUser && model.isUserLoggedIn) {
      avatar = ClipOval(
        child: CachedNetworkImage(
          width: Constants.avatarImageSize,
          height: Constants.avatarImageSize,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageUrl: model.currentUser.photoUrl ?? "",
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
