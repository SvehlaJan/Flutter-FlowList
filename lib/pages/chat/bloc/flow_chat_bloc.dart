import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flow_list/locator.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';

class FlowChatBloc extends Bloc<FlowChatEvent, FlowChatState> {
  FlowRepository _flowRepository = getIt<FlowRepository>();
  UserRepository _userRepository = getIt<UserRepository>();
  FlowRecord _flowRecord = FlowRecord.withDateTime(DateTime.now());
  bool _isEditMode = false;
  bool _isSignedIn = false;

  FlowChatBloc();

  void initBloc() async {
    _isSignedIn = _userRepository.isLoggedIn;
    print("FlowChatBloc: _isSignedIn: $_isSignedIn");

    if (_isSignedIn) {
      _flowRecord = await _flowRepository.getFlowRecord(_flowRecord.dateTime);
      _isEditMode = _flowRecord.isSaved;
      add(TypingStart());
    } else {
      add(TypingStart());
    }
  }

  @override
  get initialState {
    return FlowChatTyping.welcome();
  }

  @override
  Stream<FlowChatState> mapEventToState(FlowChatEvent event) async* {
    print("Event received! ${event.toString()}");
    print("Current state! ${state.toString()}");
    try {
      if (event is AppStarted) {
        initBloc();
        return;
      }
      if (state is FlowChatTyping) {
        if (event is TypingStart) {
          print("FlowChatTyping... waiting...");
          await new Future.delayed(const Duration(seconds: 1));
          print("FlowChatTyping... dispatching TypingDone");

          add(TypingDone());
        } else if (event is TypingDone) {
          print("FlowChatTyping... DONE!");
          yield FlowChatMessages((state as FlowChatTyping).messages);
        }
      } else if (state is FlowChatMessages) {
        ChatState chatState = (state as FlowChatMessages).latestState;
        List<ChatMessage> messages = (state as FlowChatMessages).messages;

        if (event is MessageText) {
          processMessage(chatState, messages, event.body, event.type);

          yield FlowChatTyping(messages);
          add(TypingStart());
        }
      }
    } catch (o) {
      yield FlowChatError(o.toString());
    }
  }

  void processMessage(ChatState chatState, List<ChatMessage> messages, String body, MessageType type) {
    ChatMessage userMessage = ChatMessage(chatState: chatState, messageSender: MessageSender.USER, body: body, type: type);

    ChatMessage responseMessage;
    switch (chatState) {
      case ChatState.WELCOME:
        responseMessage = ChatMessage(chatState: ChatState.ENTRY_1, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_1:
        _flowRecord.firstEntry = body;
        _flowRepository.updateFlowRecord(_flowRecord);
        responseMessage = ChatMessage(chatState: ChatState.ENTRY_2, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_2:
        _flowRecord.secondEntry = body;
        _flowRepository.updateFlowRecord(_flowRecord);
        responseMessage = ChatMessage(chatState: ChatState.ENTRY_3, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_3:
        _flowRecord.thirdEntry = body;
        _flowRepository.updateFlowRecord(_flowRecord);
        responseMessage = ChatMessage(chatState: ChatState.PICTURE, messageSender: MessageSender.BOT);
        break;
      case ChatState.PICTURE:
        _flowRecord.imageUrl = body;
        _flowRepository.updateFlowRecord(_flowRecord);
        responseMessage = ChatMessage(chatState: ChatState.WELCOME, messageSender: MessageSender.BOT);
        break;
    }

    print("Old state: $chatState, new state: ${responseMessage.chatState}");

    messages.insert(0, userMessage);
    messages.insert(0, responseMessage);
//    messages.add(responseMessage);
  }
}
