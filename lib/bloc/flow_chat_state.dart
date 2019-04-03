import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatState extends Equatable {
  FlowChatState([List props = const []]) : super(props);
}

class FlowChatLoading extends FlowChatState {
  @override
  String toString() => 'FlowChatLoading';
}

class FlowChatError extends FlowChatState {
  final String message;

  FlowChatError(this.message);

  @override
  String toString() => 'FlowChatError';
}

abstract class FlowChatContent extends FlowChatState {
  final List<ChatMessage> messages;

  FlowChatContent(this.messages) : super([messages]);

  ChatState getLatestState() {
    return messages.isEmpty ? ChatState.WELCOME : messages.first.chatState;
  }
}

class FlowChatTyping extends FlowChatContent {
  FlowChatTyping(List<ChatMessage> messages) : super(messages);

  @override
  String toString() => 'FlowChatTyping { messages: ${messages.length} }';
}

class FlowChatMessages extends FlowChatContent {

  FlowChatMessages(List<ChatMessage> messages) : super(messages);

  static FlowChatMessages welcome() {
    List<ChatMessage> messages = List<ChatMessage>();
    messages.add(ChatMessage.welcome());
    return FlowChatMessages(messages);
  }

  @override
  String toString() => 'FlowChatMessages { messages: ${messages.length} }';

}
