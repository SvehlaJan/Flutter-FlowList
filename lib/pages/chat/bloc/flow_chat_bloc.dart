import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/pages/chat/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:flutter_flow_list/models/flow_record.dart';
import 'package:flutter_flow_list/repositories/flow_repository.dart';
import 'package:flutter_flow_list/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlowChatBloc extends Bloc<FlowChatEvent, FlowChatState> {
  FlowRepository _flowRepository = FlowRepository.get();
  UserRepository _userRepository = UserRepository.get();
  FlowRecord _flowRecord = FlowRecord(DateTime.now());
  bool _isEditMode = false;
  bool _isSignedIn = false;

  FlowChatBloc();

  void initBloc() async {
    _isSignedIn = await _userRepository.isSignedInAsync();
    print("FlowChatBloc: _isSignedIn: $_isSignedIn");

    if (_isSignedIn) {
      await _flowRepository.init();
      _flowRepository.getFlowRecord().then((DocumentSnapshot snapshot) {
        if (snapshot != null && snapshot.data != null) {
          _isEditMode = true;
          _flowRecord = FlowRecord.withDateStr(
              snapshot.documentID,
              snapshot.data[FlowRecord.KEY_ENTRY_1],
              snapshot.data[FlowRecord.KEY_ENTRY_2],
              snapshot.data[FlowRecord.KEY_ENTRY_3]);
        } else {
          _isEditMode = false;
        }

        dispatch(TypingStart());
      }, onError: (Object o) {
        print(o);
      });
    } else {
      dispatch(TypingStart());
    }
  }

  @override
  Stream<FlowChatEvent> transform(Stream<FlowChatEvent> events) {
    return (events as Observable<FlowChatEvent>)
        .debounce(Duration(milliseconds: 100));
  }

  @override
  get initialState {
    return FlowChatTyping.welcome();
  }

  @override
  Stream<FlowChatState> mapEventToState(FlowChatEvent event) async* {
    print("Event received! ${event.toString()}");
    print("Current state! ${currentState.toString()}");
    try {
      if (event is AppStarted) {
        initBloc();
        return;
      }
      if (currentState is FlowChatTyping) {
        if (event is TypingStart) {
          print("FlowChatTyping... waiting...");
          await new Future.delayed(const Duration(seconds: 1));
          print("FlowChatTyping... dispatching TypingDone");

          dispatch(TypingDone());
        } else if (event is TypingDone) {
          print("FlowChatTyping... DONE!");
          yield FlowChatMessages((currentState as FlowChatTyping).messages);
        }
      } else if (currentState is FlowChatMessages) {
        ChatState chatState =
            (currentState as FlowChatMessages).getLatestState();
        List<ChatMessage> messages =
            (currentState as FlowChatMessages).messages;

        if (event is Message) {
          processMessage(chatState, messages, event.body);

          yield FlowChatTyping(messages);
          dispatch(TypingStart());
        }
      }
    } catch (o) {
      yield FlowChatError(o.toString());
    }
  }

  void processMessage(
      ChatState chatState, List<ChatMessage> messages, String body) {
    ChatMessage userMessage = ChatMessage(
        chatState: chatState, messageSender: MessageSender.USER, body: body);

    ChatMessage responseMessage;
    switch (chatState) {
      case ChatState.WELCOME:
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_1, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_1:
        _flowRecord.firstEntry = body;
        _flowRepository.setFlowRecord(_flowRecord);
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_2, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_2:
        _flowRecord.secondEntry = body;
        _flowRepository.setFlowRecord(_flowRecord);
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_3, messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_3:
        _flowRecord.thirdEntry = body;
        _flowRepository.setFlowRecord(_flowRecord);
        responseMessage = ChatMessage(
            chatState: ChatState.PICTURE, messageSender: MessageSender.BOT);
        break;
      case ChatState.PICTURE:
        responseMessage = ChatMessage(
            chatState: ChatState.WELCOME, messageSender: MessageSender.BOT);
        break;
    }

    print("Old state: $chatState, new state: ${responseMessage.chatState}");

    messages.insert(0, userMessage);
    messages.insert(0, responseMessage);
//    messages.add(responseMessage);
  }
}
