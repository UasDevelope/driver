import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatInboxEvent extends Equatable {
  const ChatInboxEvent();
  List<Object> get props => [];
}

class ChatLoadedEvent extends ChatInboxEvent {
  final String bookingId;
  const ChatLoadedEvent({required this.bookingId});
}

class SendChatMessageEvent extends ChatInboxEvent {
  final String message;
  final String? senderId;
  final String bookingId;
  const SendChatMessageEvent(
      {this.senderId, required this.message, required this.bookingId});
  @override
  List<Object> get props => [message, senderId ?? "", bookingId];
}

class JoinChatRoomEvent extends ChatInboxEvent {
  final String bookingId;
  const JoinChatRoomEvent({required this.bookingId});
  @override
  List<Object> get props => [bookingId];
}

class ChatMessageReceivedEvent extends ChatInboxEvent {
  final Map<String, dynamic> data;
  const ChatMessageReceivedEvent({required this.data});
  @override
  List<Object> get props => [data];
}

class ChatSocketErrorEvent extends ChatInboxEvent {
  final dynamic error;
  const ChatSocketErrorEvent({required this.error});
  @override
  List<Object> get props => [error];
}
