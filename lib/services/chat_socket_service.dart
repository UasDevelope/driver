import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../api/api_const.dart';
import 'local.dart';
class ChatSocketService {
  IO.Socket? _socket;
  bool _isConnected = false;
  String? _currentBookingId;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Streams for real-time updates
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<String> get errorStream => _errorController.stream;

  /// Initialize socket connection
  Future<void> connect() async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      log('🔌 Attempting to connect to chat socket...');

      // Try primary server (same as REST API)
      try {
        _socket = IO.io(
          ApiConstants.socketUrl,
          IO.OptionBuilder()
              .setTransports(['polling']) // Use polling only for now
              .setAuth({'token': token})
              .disableAutoConnect()
              .enableReconnection()
              .setReconnectionAttempts(1)
              .setReconnectionDelay(1000)
              .build(),
        );

        _setupSocketListeners();
        _socket!.connect();

        // Wait for connection with shorter timeout
        await _waitForConnection(timeoutSeconds: 5);

        if (_isConnected) {
          log('✅ Successfully connected to socket server');
          return;
        } else {
          log('⚠️ Socket connection timeout, continuing with REST API only');
        }
      } catch (error) {
        log('⚠️ Socket connection failed: $error');
        log('📡 Continuing with REST API only for chat functionality');
      }
    } catch (e) {
      log('❌ Error in socket setup: $e');
      log('📡 Chat will work with REST API only');
      // Don't rethrow, allow the app to continue with REST API
    }
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      _isConnected = true;
      log('✅ Chat socket connected');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      log('❌ Chat socket disconnected');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      log('⚠️ Chat socket connection error: $error');
      _errorController.add('Connection error: $error');
    });

    _socket!.onError((error) {
      log('🔥 Chat socket error: $error');
      _errorController.add('Socket error: $error');
    });

    // Listen for chat messages
    _socket!.on('chatMessage', (data) {
      log('📥 Chat message received: $data');
      _messageController.add(data);
    });

    // Listen for message delivery confirmation
    _socket!.on('messageDelivered', (data) {
      log('✅ Message delivered: $data');
      _messageController.add({'type': 'delivered', 'data': data});
    });

    // Listen for message read confirmation
    _socket!.on('messagesRead', (data) {
      log('👁️ Messages read: $data');
      _messageController.add({'type': 'read', 'data': data});
    });

    // Listen for room joined confirmation
    _socket!.on('roomJoined', (data) {
      log('🚪 Room joined: $data');
      _messageController.add({'type': 'roomJoined', 'data': data});
    });

    // Listen for message sent confirmation
    _socket!.on('messageSent', (data) {
      log('📤 Message sent: $data');
      _messageController.add({'type': 'sent', 'data': data});
    });

    // Listen for general errors
    _socket!.on('error', (data) {
      log('❌ Socket error: $data');
      final errorMessage = data['message'] ?? 'Unknown error';
      _errorController.add(errorMessage);
      
      // If it's an authorization error, we can still use REST API
      if (errorMessage.contains('Unauthorized') || errorMessage.contains('unauthorized')) {
        log('⚠️ Socket authorization failed, but REST API may still work');
      }
    });
  }

    /// Wait for socket connection with timeout
  Future<void> _waitForConnection({int timeoutSeconds = 10}) async {
    int attempts = 0;
    while (!_isConnected && attempts < timeoutSeconds) {
      await Future.delayed(const Duration(seconds: 1));
      attempts++;
      log('🔁 Connection attempt $attempts/$timeoutSeconds');
    }
    
    if (!_isConnected) {
      log('⚠️ Socket connection timeout, continuing with REST API only');
      // Don't throw exception, allow the app to continue with REST API fallback
    } else {
      log('✅ Socket connection established successfully');
    }
  }

  /// Join a chat room for a specific booking
  Future<void> joinChatRoom(String bookingId) async {
    // Don't join if already in the same room
    if (_currentBookingId == bookingId && _isConnected) {
      log('🚪 Already in chat room for booking: $bookingId');
      return;
    }

    // Set current booking ID first to prevent multiple joins
    _currentBookingId = bookingId;

    if (!_isConnected) {
      await connect();
    }

    try {
      log('🚪 Joining chat room for booking: $bookingId');
      _socket!.emit('joinRoom', {'bookingId': bookingId});
    } catch (e) {
      log('❌ Error joining chat room: $e');
      _errorController.add('Failed to join chat room: $e');
      rethrow;
    }
  }

  /// Send a chat message
  Future<void> sendMessage(String bookingId, String message) async {
    if (!_isConnected) {
      await connect();
    }

    try {
      log('📤 Sending message: $message');
      _socket!.emit('chatMessage', {
        'bookingId': bookingId,
        'message': message,
      });
    } catch (e) {
      log('❌ Error sending message: $e');
      _errorController.add('Failed to send message: $e');
      rethrow;
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(
      String bookingId, List<String> messageIds) async {
    if (!_isConnected) {
      await connect();
    }

    try {
      log('👁️ Marking messages as read: $messageIds');
      _socket!.emit('markAsRead', {
        'bookingId': bookingId,
        'messageIds': messageIds,
      });
    } catch (e) {
      log('❌ Error marking messages as read: $e');
      _errorController.add('Failed to mark messages as read: $e');
      rethrow;
    }
  }

  /// Leave the current chat room
  void leaveChatRoom() {
    if (_isConnected && _currentBookingId != null) {
      log('🚪 Leaving chat room: $_currentBookingId');
      _currentBookingId = null;
    }
  }

  /// Disconnect the socket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected = false;
      log('👋 Chat socket disconnected');
    }
  }

  /// Check if socket is connected
  bool get isConnected => _isConnected;

  /// Get current booking ID
  String? get currentBookingId => _currentBookingId;

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _errorController.close();
  }
}
