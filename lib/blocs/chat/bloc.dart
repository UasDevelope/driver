import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat_repository.dart';
import '../../models/chat_message.dart';
import '../../services/chat_socket_service.dart';
import '../../api/service_locator.dart';
import 'event.dart';
import 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final ChatSocketService _socketService;
  List<ChatMessage> _messages = [];
  String? _currentBookingId;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _errorSubscription;
  
  // Prevent duplicate message sending
  String? _lastSentMessage;
  DateTime? _lastSentTime;
  
  // Track processed message IDs to prevent duplicates
  final Set<String> _processedMessageIds = <String>{};
  final Set<String> _processedDeliveryIds = <String>{};

  ChatBloc({required this.chatRepository}) 
      : _socketService = sl<ChatSocketService>(),
        super(const ChatInitialState()) {
    on<LoadChatMessagesEvent>(_onLoadChatMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<CheckChatAvailabilityEvent>(_onCheckChatAvailability);
    on<ConnectToChatEvent>(_onConnectToChat);
    on<DisconnectFromChatEvent>(_onDisconnectFromChat);
    
    // Setup socket listeners
    _setupSocketListeners();
  }

  /// Clear processed message IDs when switching bookings
  void _clearProcessedIds() {
    _processedMessageIds.clear();
    _processedDeliveryIds.clear();
    log("🧹 Cleared processed message IDs for new booking");
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoadingState());
    
    try {
      log("Loading chat messages for booking: ${event.bookingId}");
      
      // Clear processed IDs if switching to a different booking
      if (_currentBookingId != null && _currentBookingId != event.bookingId) {
        _clearProcessedIds();
      }
      
      final messages = await chatRepository.getChatMessages(event.bookingId);
      _messages = messages;
      _currentBookingId = event.bookingId;
      
      log("Loaded ${messages.length} messages");
      
      // Always emit ChatMessagesLoadedState even if no messages
      // This ensures the UI shows the chat interface instead of loading
      emit(ChatMessagesLoadedState(
        messages: _messages,
        bookingId: event.bookingId,
        isConnected: _socketService.isConnected,
      ));
    } catch (e) {
      log("Error loading chat messages: $e");
      
      // If there's an error loading messages, still show the chat interface
      // with an empty message list so users can still send messages
      _messages = [];
      _currentBookingId = event.bookingId;
      
      emit(ChatMessagesLoadedState(
        messages: _messages,
        bookingId: event.bookingId,
        isConnected: _socketService.isConnected,
      ));
      
      // Show a temporary error message
      emit(ChatErrorState(message: "Could not load previous messages, but you can still send new ones"));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      log("🎯 SendMessageEvent received!");
      log("📝 Message: ${event.message}");
      log("🆔 Booking ID: ${event.bookingId}");
      
      // Prevent duplicate message sending within 2 seconds
      final now = DateTime.now();
      if (_lastSentMessage == event.message && 
          _lastSentTime != null && 
          now.difference(_lastSentTime!).inSeconds < 2) {
        log("⚠️ Duplicate message ignored: ${event.message}");
        return;
      }
      
      _lastSentMessage = event.message;
      _lastSentTime = now;
      
      // Create a temporary local message for immediate UI feedback
      final tempMessageId = DateTime.now().millisecondsSinceEpoch.toString();
      final tempMessage = ChatMessage(
        id: tempMessageId,
        senderId: 'current_user',
        senderName: 'You',
        senderRole: 'serviceProvider',
        message: event.message,
        timestamp: DateTime.now(),
        status: 'sending',
        bookingId: event.bookingId,
      );
      
      // Check if message already exists to prevent duplicates
      final existingMessage = _messages.any((msg) => 
        msg.message == event.message && 
        msg.senderId == 'current_user' &&
        msg.timestamp.difference(now).abs().inSeconds < 5
      );
      
      if (!existingMessage) {
        // Add to local list immediately for instant UI update
        _messages.add(tempMessage);
        log("📋 Temporary message added to local list. Total messages: ${_messages.length}");
      } else {
        log("⚠️ Message already exists in local list, skipping: ${event.message}");
        return;
      }
      
      // Emit loaded state immediately to show the message in UI
      emit(ChatMessagesLoadedState(
        messages: _messages,
        bookingId: event.bookingId,
        isConnected: _socketService.isConnected,
      ));
      
      // Send via REST API only (Socket.IO will handle real-time delivery automatically)
      try {
        log("🌐 Sending via REST API...");
        final sentMessage = await chatRepository.sendMessage(
          event.bookingId,
          event.message,
        );
        log("✅ API send successful: ${sentMessage.message}");
        
        // Replace temporary message with real message from API
        final tempIndex = _messages.indexWhere((msg) => msg.id == tempMessageId);
        if (tempIndex != -1) {
          _messages[tempIndex] = sentMessage;
          log("📋 Temporary message replaced with API message");
        }
        
        // Update UI with the real message
        emit(MessageSentState(message: sentMessage));
        emit(ChatMessagesLoadedState(
          messages: _messages,
          bookingId: event.bookingId,
          isConnected: _socketService.isConnected,
        ));
        
        log("🎉 Message sent successfully!");
      } catch (apiError) {
        log("❌ API send failed: $apiError");
        
        // Update temporary message status to failed
        final tempIndex = _messages.indexWhere((msg) => msg.id == tempMessageId);
        if (tempIndex != -1) {
          final failedMessage = ChatMessage(
            id: tempMessageId,
            senderId: 'current_user',
            senderName: 'You',
            senderRole: 'serviceProvider',
            message: event.message,
            timestamp: DateTime.now(),
            status: 'failed',
            bookingId: event.bookingId,
          );
          _messages[tempIndex] = failedMessage;
        }
        
        // Show error but keep the message in UI
        String errorMessage = "Failed to send message";
        if (apiError.toString().contains("Booking not found")) {
          errorMessage = "This booking is no longer available for chat";
        } else if (apiError.toString().contains("Unauthorized")) {
          errorMessage = "You don't have permission to chat for this booking";
        } else if (apiError.toString().contains("Network")) {
          errorMessage = "Network error. Please check your connection";
        }
        
        emit(ChatErrorState(message: errorMessage));
        emit(ChatMessagesLoadedState(
          messages: _messages,
          bookingId: event.bookingId,
          isConnected: _socketService.isConnected,
        ));
      }
      
    } catch (e) {
      log("❌ Error sending message: $e");
      emit(ChatErrorState(message: e.toString()));
    }
  }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    try {
      log("🔄 Processing NewMessageReceivedEvent: ${event.messageData}");
      
      // Handle the specific data format from your logs
      final data = event.messageData;
      
      // Create ChatMessage from socket data
      final newMessage = ChatMessage(
        id: data['_id']?.toString() ?? data['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: data['userId']?.toString() ?? data['senderId']?.toString() ?? 'unknown',
        senderName: data['senderName']?.toString() ?? 'Unknown User',
        senderRole: data['senderRole']?.toString() ?? 'user',
        message: data['message']?.toString() ?? '',
        timestamp: data['timestamp'] != null 
            ? DateTime.parse(data['timestamp'].toString())
            : DateTime.now(),
        status: data['status']?.toString() ?? 'sent',
        bookingId: data['bookingId']?.toString() ?? _currentBookingId ?? '',
      );
      
      log("📝 Created ChatMessage: ${newMessage.message} (ID: ${newMessage.id})");
      
      // Only add if it's for current booking and not already in the list
      if (newMessage.bookingId == _currentBookingId) {
        // Check if message already exists to prevent duplicates
        final existingMessage = _messages.any((msg) => 
          msg.id == newMessage.id || 
          (msg.message == newMessage.message && 
           msg.senderId == newMessage.senderId &&
           msg.timestamp.difference(newMessage.timestamp).abs().inSeconds < 5)
        );
        
        if (!existingMessage) {
          _messages.add(newMessage);
          log("✅ New message added to list: ${newMessage.message}");
          log("📊 Total messages: ${_messages.length}");
          
          emit(ChatMessagesLoadedState(
            messages: _messages,
            bookingId: _currentBookingId!,
            isConnected: true,
          ));
        } else {
          log("🚫 Duplicate message ignored: ${newMessage.message}");
        }
      } else {
        log("⚠️ Message for different booking (${newMessage.bookingId} vs $_currentBookingId)");
      }
    } catch (e) {
      log("❌ Error processing new message: $e");
      log("📋 Raw data: ${event.messageData}");
    }
  }

  Future<void> _onCheckChatAvailability(
    CheckChatAvailabilityEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      log("Checking chat availability for booking: ${event.bookingId}");
      final availability = await chatRepository.checkChatAvailability(event.bookingId);
      
      final isAvailable = availability['allowed'] ?? false;
      final reason = availability['reason'] ?? 'Unknown';
      
      emit(ChatAvailabilityState(
        isAvailable: isAvailable,
        reason: reason,
        bookingId: event.bookingId,
      ));
    } catch (e) {
      log("Error checking chat availability: $e");
      emit(ChatErrorState(message: e.toString()));
    }
  }

  void _onConnectToChat(
    ConnectToChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      log("Connecting to chat for booking: ${event.bookingId}");
      _currentBookingId = event.bookingId;
      
      // Try to connect to socket and join room
      try {
        await _socketService.connect();
        await _socketService.joinChatRoom(event.bookingId);
        
        // Check if socket is actually connected
        if (_socketService.isConnected) {
          emit(ChatConnectedState(bookingId: event.bookingId, isSocketConnected: true));
          log("✅ Chat connected with Socket.IO");
        } else {
          emit(ChatConnectedState(bookingId: event.bookingId, isSocketConnected: false));
          log("⚠️ Chat connected with REST API only");
        }
      } catch (socketError) {
        log("Socket connection failed, using REST API only: $socketError");
        emit(ChatConnectedState(bookingId: event.bookingId, isSocketConnected: false));
      }
      
      // Always emit ChatMessagesLoadedState after connection attempt
      // This ensures the chat interface is shown regardless of socket status
      emit(ChatMessagesLoadedState(
        messages: _messages,
        bookingId: event.bookingId,
        isConnected: _socketService.isConnected,
      ));
      log("✅ Chat interface ready to use");
      
    } catch (e) {
      log("Error connecting to chat: $e");
      emit(ChatConnectedState(bookingId: event.bookingId, isSocketConnected: false));
      
      // Even if there's an error, show the chat interface
      emit(ChatMessagesLoadedState(
        messages: _messages,
        bookingId: event.bookingId,
        isConnected: false,
      ));
    }
  }

  void _onDisconnectFromChat(
    DisconnectFromChatEvent event,
    Emitter<ChatState> emit,
  ) {
    log("Disconnecting from chat");
    _socketService.leaveChatRoom();
    _currentBookingId = null;
    emit(const ChatDisconnectedState());
  }

  // Getter for current messages
  List<ChatMessage> get messages => _messages;
  
  // Getter for current booking ID
  String? get currentBookingId => _currentBookingId;

  /// Setup socket listeners for real-time updates
  void _setupSocketListeners() {
    _messageSubscription = _socketService.messageStream.listen((data) {
      log("Socket message received: $data");
      
      // Only process messages that are not from the current user
      // to avoid adding our own messages multiple times
      if (data['type'] == null) {
        // This is a regular chat message
        final messageId = data['_id']?.toString() ?? data['id']?.toString();
        
        // Check if we've already processed this message
        if (messageId != null && _processedMessageIds.contains(messageId)) {
          log("🔄 Duplicate message ignored (ID: $messageId): ${data['message']}");
          return;
        }
        
        // Check if this is our own message (by senderId or message content)
        final isOwnMessage = data['senderId'] == 'current_user' || 
                            data['senderId'] == 'serviceProvider' ||
                            data['userId'] == 'current_user' ||
                            (data['message'] != null && _messages.any((msg) => 
                              msg.message == data['message'] && 
                              msg.timestamp.difference(DateTime.now()).abs().inSeconds < 10
                            ));
        
        if (!isOwnMessage) {
          // Regular chat message from other users
          log("📨 Processing new message from socket: ${data['message']}");
          add(NewMessageReceivedEvent(messageData: data));
          
          // Mark as processed
          if (messageId != null) {
            _processedMessageIds.add(messageId);
          }
        } else {
          log("🚫 Ignoring own message from socket: ${data['message']}");
        }
      } else if (data['type'] != null) {
        // Handle different message types
        switch (data['type']) {
          case 'delivered':
            final deliveryData = data['data'];
            final messageId = deliveryData['messageId']?.toString();
            
            // Check if we've already processed this delivery
            if (messageId != null && _processedDeliveryIds.contains(messageId)) {
              log("🔄 Duplicate delivery ignored (ID: $messageId)");
              return;
            }
            
            log("📬 Processing message delivery: $messageId");
            _updateMessageStatus(messageId, 'delivered');
            
            // Mark as processed
            if (messageId != null) {
              _processedDeliveryIds.add(messageId);
            }
            break;
            
          case 'read':
            final readData = data['data'];
            final messageIds = readData['messageIds'];
            log("👁️ Processing message read: $messageIds");
            _updateMessageStatus(messageIds, 'read');
            break;
            
          case 'sent':
            log("📤 Message sent confirmation: ${data['data']}");
            break;
            
          case 'roomJoined':
            log("🚪 Room joined: ${data['data']}");
            // Don't emit state changes from socket listeners
            // The connection method will handle state transitions
            break;
            
          default:
            log("❓ Unknown message type: ${data['type']}");
            break;
        }
      }
    });

    _errorSubscription = _socketService.errorStream.listen((error) {
      log("Socket error: $error");
      // Don't add error events that might cause screen to close
      // Just log the error and continue
    });
  }

  /// Update message status (delivered, read)
  void _updateMessageStatus(dynamic messageIdOrIds, String status) {
    if (messageIdOrIds is String) {
      // Single message
      final index = _messages.indexWhere((msg) => msg.id == messageIdOrIds);
      if (index != -1) {
        // Create new message with updated status
        final oldMessage = _messages[index];
        final newMessage = ChatMessage(
          id: oldMessage.id,
          senderId: oldMessage.senderId,
          senderName: oldMessage.senderName,
          senderRole: oldMessage.senderRole,
          message: oldMessage.message,
          timestamp: oldMessage.timestamp,
          status: status,
          bookingId: oldMessage.bookingId,
        );
        _messages[index] = newMessage;
      }
    } else if (messageIdOrIds is List) {
      // Multiple messages
      for (final id in messageIdOrIds) {
        final index = _messages.indexWhere((msg) => msg.id == id);
        if (index != -1) {
          final oldMessage = _messages[index];
          final newMessage = ChatMessage(
            id: oldMessage.id,
            senderId: oldMessage.senderId,
            senderName: oldMessage.senderName,
            senderRole: oldMessage.senderRole,
            message: oldMessage.message,
            timestamp: oldMessage.timestamp,
            status: status,
            bookingId: oldMessage.bookingId,
          );
          _messages[index] = newMessage;
        }
      }
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _errorSubscription?.cancel();
    _socketService.dispose();
    return super.close();
  }
}
