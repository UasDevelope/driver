import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:driver/services/local.dart';
import '../api/api_const.dart';

class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  /// Initialize the socket with retry logic
  Future<void> initSocket({int maxAttempts = 10}) async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);

      log('🔌 Connecting to socket with token: $token');

      _socket = IO.io(
        ApiConstants.socketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'auth': {
            'token': token,
          },
        },
      );

      int attempt = 0;
      final completer = Completer<void>();

      _socket.onConnect((_) {
        _isConnected = true;
        log('✅ Socket connected on attempt ${attempt + 1}');
        if (!completer.isCompleted) completer.complete();
      });

      _socket.onDisconnect((_) {
        _isConnected = false;
        log('❌ Socket disconnected');
      });

      _socket.onConnectError((err) {
        _isConnected = false;
        log('⚠️ Connect error: $err');
      });

      _socket.onError((err) {
        _isConnected = false;
        log('🔥 Socket error: $err');
      });

      while (!_isConnected && attempt < maxAttempts) {
        attempt++;
        log('🔁 Attempt $attempt to connect socket...');
        _socket.connect();
        await Future.delayed(const Duration(milliseconds: 800));

        if (_isConnected) break;
      }

      if (!_isConnected && !completer.isCompleted) {
        log('❌ Socket failed to connect after $maxAttempts attempts.');
        completer.completeError(
          'Socket failed to connect after $maxAttempts attempts.',
        );
      }

      await completer.future;
    } catch (e) {
      log('❌ Error in initSocket: $e');
      _isConnected = false;
      rethrow;
    }
  }

  /// Emit an event with optional data
  void emit(String event, dynamic data) {
    try {
      if (_isConnected) {
        log('📤 Emitting event [$event] with data: $data');
        _socket.emit(event, data);
      } else {
        log('⚠️ Cannot emit [$event] — socket not connected');
      }
    } catch (e) {
      log('❌ Error in emit: $e');
    }
  }

  /// Listen to an event
  Future<void> on(String event, Function(dynamic) callback) async {
    _socket.off(event);
    await Future.delayed(const Duration(milliseconds: 100));
    _socket.on(event, (data) {
      log('📥 Received event [$event]: $data');
      callback(data);
    });
  }

  /// Disconnect the socket
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      log('👋 Socket manually disconnected');
    }
  }

  /// Check if socket is connected
  bool get isConnected => _isConnected;

  /// Check if socket is ready
  bool get isReady => _socket != null && _isConnected;

  /// Ensure socket is connected and emit an event
  Future<void> ensureConnectedAndEmit(String event, dynamic data) async {
    try {
      if (_socket == null || !_isConnected) {
        log('⚠️ Socket not ready. Trying to re-initialize...');
        await initSocket();
      }

      if (_isConnected) {
        log('📤 Emitting event [$event] with data: $data');
        _socket.emit(event, data);
      } else {
        log('❌ Still not connected. Cannot emit [$event]');
      }
    } catch (e) {
      log('❌ Error in ensureConnectedAndEmit: $e');
    }
  }

  /// Wait until socket is ready (connected) or timeout
  Future<void> waitUntilReady({int timeoutMs = 5000}) async {
    int waited = 0;
    while (!_isConnected && waited < timeoutMs) {
      await Future.delayed(const Duration(milliseconds: 200));
      waited += 200;
    }

    if (!_isConnected) {
      throw Exception('Socket not ready after waiting $timeoutMs ms');
    }
  }
}
