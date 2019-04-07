import 'package:equatable/equatable.dart';

enum ChatState { WELCOME, ENTRY_1, ENTRY_2, ENTRY_3, PICTURE }

enum MessageSender { BOT, USER }

enum MessageType { TEXT, IMAGE }

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

  String getMessageBody() {
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

  @override
  String toString() => 'ChatMessage { chatState: $chatState }';
}
