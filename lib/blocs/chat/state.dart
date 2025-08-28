import 'package:equatable/equatable.dart';
import '../../models/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {
  const ChatInitialState();
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

class ChatMessagesLoadedState extends ChatState {
  final List<ChatMessage> messages;
  final String bookingId;
  final bool isConnected;

  const ChatMessagesLoadedState({
    required this.messages,
    required this.bookingId,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [messages, bookingId, isConnected];
}

class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatAvailabilityState extends ChatState {
  final bool isAvailable;
  final String reason;
  final String bookingId;

  const ChatAvailabilityState({
    required this.isAvailable,
    required this.reason,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [isAvailable, reason, bookingId];
}

class MessageSendingState extends ChatState {
  const MessageSendingState();
}

class MessageSentState extends ChatState {
  final ChatMessage message;

  const MessageSentState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatConnectedState extends ChatState {
  final String bookingId;
  final bool isSocketConnected;

  const ChatConnectedState({
    required this.bookingId,
    this.isSocketConnected = true,
  });

  @override
  List<Object?> get props => [bookingId, isSocketConnected];
}

class ChatDisconnectedState extends ChatState {
  const ChatDisconnectedState();
}
