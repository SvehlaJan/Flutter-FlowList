import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TypingStart extends FlowChatEvent {}

class TypingDone extends FlowChatEvent {}

class UserMessage extends FlowChatEvent {
  final String body;
  final MessageType type;

  UserMessage(this.body, this.type);

  @override
  List<Object> get props => [body, type];

  @override
  String toString() {
    return 'UserMessage{body: $body, type: $type}';
  }
}
