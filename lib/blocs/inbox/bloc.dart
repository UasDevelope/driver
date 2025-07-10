import 'dart:developer';

import 'package:driver/blocs/inbox/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy/chat_inbox.dart';
import '../../models/chat_inbox.dart';
import '../../services/socket_service.dart';
import 'event.dart';

class ChatInboxBloc extends Bloc<ChatInboxEvent, ChatInboxState> {
  List<ChatInboxModel> _chatList = []; // store messages here
  final SocketService _socketService = SocketService();

  ChatInboxBloc() : super(ChatInboxInitialState()) {
    on<ChatLoadedEvent>(_onLoadChat);
    on<SendChatMessageEvent>(_onSendMessage);
    on<JoinChatRoomEvent>(_onJoinRoom);
    on<ChatMessageReceivedEvent>(_onMessageReceived);
    on<ChatSocketErrorEvent>(_onSocketError);
  }

  void _onLoadChat(ChatLoadedEvent event, Emitter<ChatInboxState> emit) {
    emit(ChatInboxLoadingState());
    try {
      final chatInboxData = ChatInboxData();
      _chatList = chatInboxData.chatInbox
          .map((e) => ChatInboxModel.fromMap(e))
          .toList();
      emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
    } catch (e) {
      log("Error loading chat: $e");
    }
  }

  void _onSendMessage(
    SendChatMessageEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    final newMessage = ChatInboxModel(
      message: event.message,
      senderId: event.senderId,
      recievrId: "receiver_123", // can adjust logic later
      time: DateTime.now(),
      url: "",
      isMe: true,
    );
    _chatList.add(newMessage);
    emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
    // Emit socket event with actual bookingId
    _socketService.emit('chatMessage', {
      'bookingId': event.bookingId,
      'message': event.message,
    });
  }

  Future<void> _onJoinRoom(
    JoinChatRoomEvent event,
    Emitter<ChatInboxState> emit,
  ) async {
    await _socketService.initSocket();
    _socketService.emit('joinRoom', {'bookingId': event.bookingId});
    // Listen for chat messages
    await _socketService.on('chatMessage', (data) {
      log('Socket message received: $data');
      // For now, just print. In future, dispatch ChatMessageReceivedEvent.
    });
    // Listen for errors
    await _socketService.on('error', (err) {
      log('Socket error: $err');
      // For now, just print. In future, dispatch ChatSocketErrorEvent.
    });
  }

  void _onMessageReceived(
    ChatMessageReceivedEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    // For now, just print the message
    log('Received message: ${event.data}');
    // In future, add to _chatList and emit loaded state
  }

  void _onSocketError(
    ChatSocketErrorEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    log('Socket error: ${event.error}');
    emit(ChatInboxErrorState(error: event.error));
  }
}
