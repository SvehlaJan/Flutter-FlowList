import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flow_list/bloc/flow_chat_event.dart';
import 'package:flutter_flow_list/bloc/flow_chat_state.dart';
import 'package:flutter_flow_list/models/chat_message.dart';
import 'package:rxdart/rxdart.dart';

class FlowChatBloc extends Bloc<FlowChatEvent, FlowChatState> {
  FlowChatBloc();

  @override
  Stream<FlowChatEvent> transform(Stream<FlowChatEvent> events) {
    return (events as Observable<FlowChatEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  get initialState {
    return FlowChatMessages.welcome();
  }

  @override
  Stream<FlowChatState> mapEventToState(FlowChatEvent event) async* {
    print("Event received! ${event.toString()}");
    print("Current state! ${currentState.toString()}");
    try {
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

  void processMessage(ChatState chatState, List<ChatMessage> messages, String body) {
    ChatMessage userMessage = ChatMessage(
        chatState: chatState,
        messageSender: MessageSender.USER,
        body: body);

    ChatMessage responseMessage;
    switch (chatState) {
      case ChatState.WELCOME:
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_1,
            messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_1:
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_2,
            messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_2:
        responseMessage = ChatMessage(
            chatState: ChatState.ENTRY_3,
            messageSender: MessageSender.BOT);
        break;
      case ChatState.ENTRY_3:
        responseMessage = ChatMessage(
            chatState: ChatState.PICTURE,
            messageSender: MessageSender.BOT);
        break;
      case ChatState.PICTURE:
        responseMessage = ChatMessage(
            chatState: ChatState.WELCOME,
            messageSender: MessageSender.BOT);
        break;
    }

    print(
        "Old state: $chatState, new state: ${responseMessage.chatState}");

    messages.insert(0, userMessage);
    messages.insert(0, responseMessage);
//    messages.add(responseMessage);
  }
}
