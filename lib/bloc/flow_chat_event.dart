import 'package:equatable/equatable.dart';

abstract class FlowChatEvent extends Equatable {}

class Message extends FlowChatEvent {
  final String body;

  Message({this.body});

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
