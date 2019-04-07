import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatEvent extends Equatable {}

class AppStarted extends FlowChatEvent {
  @override
  String toString() => 'AppStarted { }';
}

class MessageText extends FlowChatEvent {
  final String body;
  final MessageType type;

  MessageText({this.body, this.type});

  @override
  String toString() => 'Message { body: $body }';
}

class TypingStart extends FlowChatEvent {
  @override
  String toString() => 'TypingStart { }';
}

class TypingDone extends FlowChatEvent {
  @override
  String toString() => 'TypingDone { }';
}
