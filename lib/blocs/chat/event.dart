import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatMessagesEvent extends ChatEvent {
  final String bookingId;

  const LoadChatMessagesEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class SendMessageEvent extends ChatEvent {
  final String bookingId;
  final String message;

  const SendMessageEvent({required this.bookingId, required this.message});

  @override
  List<Object?> get props => [bookingId, message];
}

class NewMessageReceivedEvent extends ChatEvent {
  final Map<String, dynamic> messageData;

  const NewMessageReceivedEvent({required this.messageData});

  @override
  List<Object?> get props => [messageData];
}

class CheckChatAvailabilityEvent extends ChatEvent {
  final String bookingId;

  const CheckChatAvailabilityEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class ConnectToChatEvent extends ChatEvent {
  final String bookingId;

  const ConnectToChatEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class DisconnectFromChatEvent extends ChatEvent {
  const DisconnectFromChatEvent();
}

