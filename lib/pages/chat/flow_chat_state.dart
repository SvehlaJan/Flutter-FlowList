import 'package:equatable/equatable.dart';
import 'package:flutter_flow_list/models/chat_message.dart';

abstract class FlowChatContent extends Equatable {
  final List<ChatHistoryMessage> messageHistory;

  FlowChatContent(this.messageHistory);

  ChatStage get chatStage => messageHistory.isEmpty ? ChatStage.WELCOME : messageHistory.first.chatStage;

  List<ChatAction> get chatActions => messageHistory.isEmpty ? List() : messageHistory.first.chatActions;

  @override
  List<Object> get props => [messageHistory];
}

class FlowChatTyping extends FlowChatContent {
  FlowChatTyping(List<ChatHistoryMessage> messages) : super(messages);

  static FlowChatTyping welcome() => FlowChatTyping([ChatHistoryMessage.welcome()]);

  @override
  String toString() => 'FlowChatTyping { messageHistory: ${messageHistory.length} }';
}

class FlowChatMessages extends FlowChatContent {
  FlowChatMessages(List<ChatHistoryMessage> messages) : super(messages);

  static FlowChatMessages welcome() => FlowChatMessages([ChatHistoryMessage.welcome()]);

  @override
  String toString() => 'FlowChatMessages { messageHistory: ${messageHistory.length} }';
}
