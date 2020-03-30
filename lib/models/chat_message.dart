import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flow_list/util/R.dart';

enum ChatStage { WELCOME, ENTRY_1, ENTRY_2, ENTRY_3, PICTURE, GIF, FINISHED }

enum ChatActionType { GO, SKIP, PHOTO, GALLERY, GIF }

enum MessageSender { BOT, USER }

enum MessageType { TEXT, SKIP, IMAGE, GIF }

class ChatAction extends Equatable {
  final ChatActionType type;

  ChatAction(this.type);

  get label {
    switch (type) {
      case ChatActionType.GO:
        return R.sString.chat_action_lets_do_it;
      case ChatActionType.SKIP:
        return R.sString.chat_action_skip;
      case ChatActionType.PHOTO:
        return R.sString.chat_action_photo;
      case ChatActionType.GALLERY:
        return R.sString.chat_action_gallery;
      case ChatActionType.GIF:
        return R.sString.chat_action_gif;
    }
  }

  get avatar {
    switch (type) {
      case ChatActionType.GO:
        return Icons.check;
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

  factory ChatAction.go() => ChatAction(ChatActionType.GO);

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
          return R.sString.chat_bot_welcome;
        case ChatStage.ENTRY_1:
          return R.sString.chat_bot_entry_1;
        case ChatStage.ENTRY_2:
          return R.sString.chat_bot_entry_2;
        case ChatStage.ENTRY_3:
          return R.sString.chat_bot_entry_3;
        case ChatStage.PICTURE:
          return R.sString.chat_bot_picture;
        case ChatStage.GIF:
          return R.sString.chat_bot_gif;
        case ChatStage.FINISHED:
          return R.sString.chat_bot_finished;
      }
    }

    return body ?? "Null :-(";
  }

  get chatActions {
    switch (chatStage) {
      case ChatStage.WELCOME:
        return [
          ChatAction.go(),
        ];
      case ChatStage.ENTRY_1:
        return [
          ChatAction.skip(),
        ];
      case ChatStage.ENTRY_2:
        return [
          ChatAction.skip(),
        ];
      case ChatStage.ENTRY_3:
        return [
          ChatAction.skip(),
        ];
      case ChatStage.PICTURE:
        return [
          ChatAction.skip(),
          ChatAction.photo(),
          ChatAction.gallery(),
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
