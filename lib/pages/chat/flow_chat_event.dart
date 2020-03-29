import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatEvent extends Equatable {
  FlowChatEvent();
}

class AppStarted extends FlowChatEvent {
  @override
  String toString() => 'AppStarted { }';

  @override
  List<Object> get props => [];
}

class UserMessage extends FlowChatEvent {
  final String body;
  final MessageType type;

  UserMessage({this.body, this.type});

  @override
  String toString() => 'Message { body: $body }';

  @override
  List<Object> get props => [body, type];
}

class TypingStart extends FlowChatEvent {
  @override
  String toString() => 'TypingStart { }';

  @override
  List<Object> get props => [];
}

class TypingDone extends FlowChatEvent {
  @override
  String toString() => 'TypingDone { }';

  @override
  List<Object> get props => [];
}
