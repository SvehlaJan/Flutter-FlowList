import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ChatState { WELCOME, ENTRY_1, ENTRY_2, ENTRY_3, PICTURE }

enum ChatActionType { TEXT, SKIP, PHOTO, GALERY }

enum MessageSender { BOT, USER }

enum MessageType { TEXT, IMAGE }

class ChatAction {
  ChatActionType type;

  ChatAction(this.type);

  get label {
    switch(type) {
      case ChatActionType.TEXT:
        return "Text";
      case ChatActionType.SKIP:
        return "Skip";
      case ChatActionType.PHOTO:
        return "Photo";
      case ChatActionType.GALERY:
        return "Gallery";
        break;
    }
  }

  get avatar {
    switch(type) {
      case ChatActionType.TEXT:
        return null;
      case ChatActionType.SKIP:
        return Icons.skip_next;
      case ChatActionType.PHOTO:
        return Icons.camera_alt;
      case ChatActionType.GALERY:
        return Icons.image;
        break;
    }
  }
}

class ChatMessage extends Equatable {
  final ChatState chatState;
  final MessageSender messageSender;
  final String body;
  final MessageType type;

  ChatMessage(
      {this.chatState,
      this.messageSender,
      this.body,
      this.type = MessageType.TEXT})
      : super([chatState, messageSender, body, type]);

  ChatMessage.welcome()
      : chatState = ChatState.WELCOME,
        messageSender = MessageSender.BOT,
        body = null,
        type = MessageType.TEXT;

  get messageBody {
    if (messageSender == MessageSender.BOT) {
      switch (chatState) {
        case ChatState.WELCOME:
          return "Welcome back, ";
        case ChatState.ENTRY_1:
          return "Entry 1";
        case ChatState.ENTRY_2:
          return "Entry 2";
        case ChatState.ENTRY_3:
          return "Entry 3";
        case ChatState.PICTURE:
          return "Picture";
      }
    }

    return body ?? "Null :-(";
  }

  get chatActions {
    List<ChatAction> actions = new List();
    switch (chatState) {
      case ChatState.WELCOME:
        actions.add(ChatAction(ChatActionType.TEXT));
        actions.add(ChatAction(ChatActionType.SKIP));
        actions.add(ChatAction(ChatActionType.PHOTO));
        actions.add(ChatAction(ChatActionType.GALERY));
        break;
      case ChatState.ENTRY_1:
        actions.add(ChatAction(ChatActionType.TEXT));
        actions.add(ChatAction(ChatActionType.SKIP));
        break;
      case ChatState.ENTRY_2:
        actions.add(ChatAction(ChatActionType.TEXT));
        actions.add(ChatAction(ChatActionType.SKIP));
        break;
      case ChatState.ENTRY_3:
        actions.add(ChatAction(ChatActionType.TEXT));
        actions.add(ChatAction(ChatActionType.SKIP));
        break;
      case ChatState.PICTURE:
        actions.add(ChatAction(ChatActionType.TEXT));
        actions.add(ChatAction(ChatActionType.SKIP));
        break;
    }
    return actions;
  }

  @override
  String toString() => 'ChatMessage { chatState: $chatState }';
}
