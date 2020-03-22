import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatState extends Equatable {
  FlowChatState();
}

class FlowChatLoading extends FlowChatState {
  @override
  String toString() => 'FlowChatLoading';

  @override
  List<Object> get props => [];
}

class FlowChatError extends FlowChatState {
  final String message;

  FlowChatError(this.message);

  @override
  String toString() => 'FlowChatError';

  @override
  List<Object> get props => [message];
}

abstract class FlowChatContent extends FlowChatState {
  final List<ChatMessage> messages;

  FlowChatContent(this.messages);

  get latestState {
    return messages.isEmpty ? ChatState.WELCOME : messages.first.chatState;
  }

  get chatActions {
    return messages.isEmpty ? List() : messages.first.chatActions;
  }

  @override
  List<Object> get props => [messages];
}

class FlowChatTyping extends FlowChatContent {
  FlowChatTyping(List<ChatMessage> messages) : super(messages);

  static FlowChatTyping welcome() => FlowChatTyping([ChatMessage.welcome()]);

  @override
  String toString() => 'FlowChatTyping { messages: ${messages.length} }';
}

class FlowChatMessages extends FlowChatContent {
  FlowChatMessages(List<ChatMessage> messages) : super(messages);

  static FlowChatMessages welcome() =>
      FlowChatMessages([ChatMessage.welcome()]);

  @override
  String toString() => 'FlowChatMessages { messages: ${messages.length} }';
}
