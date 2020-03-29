import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ChatStage { WELCOME, ENTRY_1, ENTRY_2, ENTRY_3, PICTURE, GIF, FINISHED }

enum ChatActionType { TEXT, SKIP, PHOTO, GALLERY, GIF }

enum MessageSender { BOT, USER }

enum MessageType { TEXT, SKIP, IMAGE, GIF }

class ChatAction extends Equatable {
  final ChatActionType type;

  ChatAction(this.type);

  get label {
    switch (type) {
      case ChatActionType.TEXT:
        return "Text";
      case ChatActionType.SKIP:
        return "Skip";
      case ChatActionType.PHOTO:
        return "Photo";
      case ChatActionType.GALLERY:
        return "Gallery";
      case ChatActionType.GIF:
        return "GIF";
    }
  }

  get avatar {
    switch (type) {
      case ChatActionType.TEXT:
        return Icons.text_fields;
      case ChatActionType.SKIP:
        return Icons.skip_next;
      case ChatActionType.PHOTO:
        return Icons.camera_alt;
      case ChatActionType.GALLERY:
        return Icons.image;
      case ChatActionType.GIF:
        return Icons.gif;
    }
  }

  factory ChatAction.text() => ChatAction(ChatActionType.TEXT);

  factory ChatAction.skip() => ChatAction(ChatActionType.SKIP);

  factory ChatAction.photo() => ChatAction(ChatActionType.PHOTO);

  factory ChatAction.gallery() => ChatAction(ChatActionType.GALLERY);

  factory ChatAction.gif() => ChatAction(ChatActionType.GIF);

  @override
  List<Object> get props => [type];
}

class ChatHistoryMessage extends Equatable {
  final ChatStage chatStage;
  final MessageSender messageSender;
  final String body;
  final MessageType type;

  @override
  List<Object> get props => [chatStage, messageSender, body, type];

  ChatHistoryMessage(this.chatStage, this.messageSender, {this.body, this.type = MessageType.TEXT});

  ChatHistoryMessage.welcome()
      : chatStage = ChatStage.WELCOME,
        messageSender = MessageSender.BOT,
        body = null,
        type = MessageType.TEXT;

  get messageBody {
    if (messageSender == MessageSender.BOT) {
      switch (chatStage) {
        case ChatStage.WELCOME:
          return "Welcome back, ";
        case ChatStage.ENTRY_1:
          return "Entry 1";
        case ChatStage.ENTRY_2:
          return "Entry 2";
        case ChatStage.ENTRY_3:
          return "Entry 3";
        case ChatStage.PICTURE:
          return "Picture";
        case ChatStage.GIF:
          return "Gif";
        case ChatStage.FINISHED:
          return "Congrats!";
      }
    }

    return body ?? "Null :-(";
  }

  get chatActions {
    switch (chatStage) {
      case ChatStage.WELCOME:
        return [
          ChatAction.skip(),
          ChatAction.gif(),
        ];
      case ChatStage.ENTRY_1:
        return [
          ChatAction.skip(),
          ChatAction.gif(),
        ];
      case ChatStage.ENTRY_2:
        return [
          ChatAction.skip(),
          ChatAction.gif(),
        ];
      case ChatStage.ENTRY_3:
        return [
          ChatAction.skip(),
          ChatAction.gif(),
        ];
      case ChatStage.PICTURE:
        return [
          ChatAction.skip(),
          ChatAction.photo(),
          ChatAction.gallery(),
          ChatAction.gif(),
        ];
      case ChatStage.GIF:
        return [
          ChatAction.gif(),
        ];
      case ChatStage.FINISHED:
        return [];
    }
  }

  @override
  String toString() => 'ChatMessage { chatState: $chatStage }';
}
