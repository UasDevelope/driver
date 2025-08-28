import 'dart:developer';
import 'package:driver/blocs/inbox/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../api/api_const.dart';
import '../../api/base_api_client.dart';
import '../../models/chat_inbox.dart';
import '../../services/local.dart';
import '../../services/socket_service.dart';
import '../../utils/custom_jwt_decoder.dart';
import 'event.dart';

class ChatInboxBloc extends Bloc<ChatInboxEvent, ChatInboxState> {
  List<ChatInboxModel> _chatList = []; // store messages here
  final SocketService _socketService = SocketService();
  String _currentUserId = "";

  ChatInboxBloc() : super(ChatInboxInitialState()) {
    on<ChatLoadedEvent>(_onLoadChat);
    on<SendChatMessageEvent>(_onSendMessage);
    on<JoinChatRoomEvent>(_onJoinRoom);
    on<ChatMessageReceivedEvent>(_onMessageReceived);
    on<ChatSocketErrorEvent>(_onSocketError);
  }

  Future<void> _onLoadChat(
      ChatLoadedEvent event, Emitter<ChatInboxState> emit) async {
    emit(ChatInboxLoadingState());
    try {
      // Start with empty list for real-time chat
      _chatList = [];
      final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
      var response = await apiClient
          .get("${ApiConstants.baseUrl}/chat/${event.bookingId}");
      log("Response for the chat is $response");

      if (response != null && response['messages'] != null) {
        final List<dynamic> messagesJson = response['messages'];

        _chatList = messagesJson.map((msg) {
          final bool isMe = msg['senderId'] == _currentUserId;
          log("Message senderId: ${msg['senderId']},current userId $_currentUserId isMe: $isMe");

          return ChatInboxModel.fromMap(
            {
              ...msg,
              'userId': msg['senderId'],
              'isMe': isMe,
            },
          );
        }).toList();

        emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
      }
    } catch (e) {
      log("Error loading chat: $e");
    }
  }

  Future<String> _decodeToken() async {
    final userToken = await LocalStorage.getString(LocalStorage.AcessToken);

    if (userToken != null) {
      Map<String, dynamic> decodedToken = CustomJwtDecoder.decode(userToken);
      _currentUserId = decodedToken["id"];
      log("Current user id is $_currentUserId");
      return decodedToken["id"];
    }
    return "";
  }

  void _onSendMessage(
    SendChatMessageEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    // // Create a temporary message for immediate UI feedback
    // final tempMessage = ChatInboxModel(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
    //   message: event.message,
    //   senderId: _currentUserId,
    //   recievrId: "", // Will be set by server
    //   time: DateTime.now(),
    //   url: "",
    //   isMe: true,
    //   senderName: "You", // Will be replaced by server response
    //   senderRole: "driver",
    //   status: "sending",
    //   bookingId: event.bookingId,
    // );
    //
    // // Add to list and emit state
    // _chatList.add(tempMessage);
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
    _decodeToken();
    await _socketService.initSocket();
    await _socketService
        .ensureConnectedAndEmit('joinRoom', {'bookingId': event.bookingId});
    await _socketService
        .ensureConnectedAndEmit('trackBooking', {'bookingId': event.bookingId});

    // Listen for chat messages
    await _socketService.on('chatMessage', (data) {
      log('Socket message received: $data');

      // Dispatch event instead of directly emitting state
      add(ChatMessageReceivedEvent(data: data));
    });
    await _socketService.on('locationUpdate', (data) {
      log("Socket data is $data");
    });
    await _socketService.on('locationRecieve', (data) {
      log("Socket data is $data");
    });

    // Listen for errors
    await _socketService.on('error', (err) {
      log('Socket error: $err');
      add(ChatSocketErrorEvent(error: err));
    });
  }

  void _onMessageReceived(
    ChatMessageReceivedEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    final data = event.data;

    // Check if message already exists to prevent duplicates
    final messageId = data['_id'];
    final existingMessage = _chatList.any((msg) => msg.id == messageId);

    if (!existingMessage) {
      // Create message from socket data
      final newMessage = ChatInboxModel.fromSocketData(data, _currentUserId);

      // Remove temporary message if it exists (same content, different ID)
      _chatList.removeWhere((msg) =>
          msg.id?.startsWith('temp_') == true &&
          msg.message == newMessage.message &&
          msg.isMe == newMessage.isMe);

      // Add new message
      _chatList.add(newMessage);

      // Emit updated state
      emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
    }
  }

  void _onSocketError(
    ChatSocketErrorEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    log('Socket error: ${event.error}');
    emit(ChatInboxErrorState(error: event.error));
  }
}
