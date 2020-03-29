import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/flow_chat_state.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/util/constants.dart';
import 'package:flutter_flow_list/viewmodels/base_model.dart';
import 'package:giphy_client/src/models/gif.dart';
import 'package:image_picker/image_picker.dart';

class ChatViewModel extends BaseModel {
  FlowRepository _flowRepository = getIt<FlowRepository>();
  FlowRecord _record = FlowRecord.withDateTime(DateTime.now());

  FlowChatContent _chatState;

  FlowChatContent get state => _chatState;

  @protected
  StreamController<List<ChatAction>> _chatActionsController = StreamController.broadcast();

  Stream<List<ChatAction>> get chatActionsStream => _chatActionsController.stream;

  @override
  void dispose() {
    super.dispose();
    _chatActionsController.close();
  }

  void startChat() async {
    if (_chatState != null) {
      // Chat was already started. This ViewModel is reusable so we will just continue.
      _chatActionsController.add(_chatState.chatActions);
      return;
    }

    _chatState = FlowChatTyping.welcome();
    notifyListeners();

    if (isUserLoggedIn) {
      _record = await _flowRepository.getFlowRecord(DateTime.now());
    }

    _sendMessagesWithDelay();
  }

  void onMessageSent(UserMessage userMessage) async {
    processMessage(userMessage);

    _chatState = FlowChatTyping(_chatState.messageHistory);
    notifyListeners();

    _sendMessagesWithDelay();
  }

  void onGifSelected(GiphyGif gif) {
    _record.gifUrl = gif.embedUrl;
  }

  void _sendMessagesWithDelay() async {
    await new Future.delayed(const Duration(seconds: 1));
    _chatState = FlowChatMessages(_chatState.messageHistory);
    notifyListeners();
    _chatActionsController.add(_chatState.chatActions);
  }

  void processMessage(UserMessage userMessage) {
    ChatHistoryMessage receivedMessage = ChatHistoryMessage(_chatState.chatStage, MessageSender.USER, body: userMessage.body, type: userMessage.type);

    ChatHistoryMessage responseMessage;
    switch (_chatState.chatStage) {
      case ChatStage.WELCOME:
        responseMessage = ChatHistoryMessage(ChatStage.ENTRY_1, MessageSender.BOT);
        break;
      case ChatStage.ENTRY_1:
        _record.firstEntry = userMessage.body;
        _updateFlowRecord();
        responseMessage = ChatHistoryMessage(ChatStage.ENTRY_2, MessageSender.BOT);
        break;
      case ChatStage.ENTRY_2:
        _record.secondEntry = userMessage.body;
        _updateFlowRecord();
        responseMessage = ChatHistoryMessage(ChatStage.ENTRY_3, MessageSender.BOT);
        break;
      case ChatStage.ENTRY_3:
        _record.thirdEntry = userMessage.body;
        _updateFlowRecord();
        responseMessage = ChatHistoryMessage(ChatStage.PICTURE, MessageSender.BOT);
        break;
      case ChatStage.PICTURE:
        _record.imageUrl = userMessage.body;
        _updateFlowRecord();
        responseMessage = ChatHistoryMessage(ChatStage.GIF, MessageSender.BOT);
        break;
      case ChatStage.GIF:
        _record.gifUrl = userMessage.body;
        _updateFlowRecord();
        responseMessage = ChatHistoryMessage(ChatStage.WELCOME, MessageSender.BOT);
        break;
      case ChatStage.FINISHED:
        // TODO: Handle this case.
        break;
    }

    print("Old state: ${_chatState.chatStage}, new state: ${responseMessage.chatStage}");

    _chatState.messageHistory.insert(0, receivedMessage);
    _chatState.messageHistory.insert(0, responseMessage);
  }

  void _updateFlowRecord() {
//    _flowRepository.updateFlowRecord(_record);
  }

  Future<void> getImage(ImageSource source) async {
    setBusy(true);

    File imageFile = await ImagePicker.pickImage(source: source, maxHeight: Constants.uploadImageMaxSize, maxWidth: Constants.uploadImageMaxSize);

    if (imageFile != null) {
      await uploadFile(imageFile);
    } else {
      setBusy(false);
    }
  }

  Future<void> uploadFile(File imageFile) async {
    _flowRepository.uploadImage(imageFile, DateTime.now()).then((downloadUrl) {
      _record.imageUrl = downloadUrl;
      setBusy(false);
    }, onError: (err) {
      showSnackBarController.add("This file is not an image");
      setBusy(false);
    });
  }
}
