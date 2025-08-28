import 'package:driver/api/api_const.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/models/chat_message.dart';
import '../api/service_locator.dart';
import '../utils/network_utils.dart';
import 'dart:developer';

class ChatRepository {
  final BaseApiClient apiClient = sl<BaseApiClient>();

  // Get chat messages for a booking
  Future<List<ChatMessage>> getChatMessages(String bookingId) async {
    try {
      log("Fetching chat messages for booking: $bookingId");
      
      final response = await apiClient.get('${ApiConstants.getChatHistory}/$bookingId');
      
      log("Get messages response: $response");
      
      if (response is Map<String, dynamic> && response.containsKey('messages')) {
        final List<dynamic> messagesList = response['messages'] ?? [];
        return messagesList
            .map((message) => ChatMessage.fromJson(message))
            .toList();
      } else if (response is Map<String, dynamic> && response.containsKey('message')) {
        // If no messages found, return empty list
        log("No messages found: ${response['message']}");
        return [];
      } else {
        log("Invalid response format: $response");
        return []; // Return empty list instead of throwing error
      }
    } catch (e) {
      log("Error fetching messages: $e");
      // Use NetworkUtils for consistent error handling
      final errorMessage = NetworkUtils.getErrorMessage(e);
      log("User-friendly error: $errorMessage");
      return []; // Return empty list instead of throwing error
    }
  }

  // Send a message with retry mechanism
  Future<ChatMessage> sendMessage(String bookingId, String message) async {
    int maxRetries = 3;
    int currentRetry = 0;
    
    while (currentRetry < maxRetries) {
      try {
        log("Sending message via API (attempt ${currentRetry + 1}/$maxRetries):");
        log("Booking ID: $bookingId");
        log("Message: $message");
        
        final response = await apiClient.post(
          '${ApiConstants.sendChatMessage}',
          {
            'bookingId': bookingId,
            'message': message,
          },
        );
        
        log("API Response: $response");
        
        if (response is Map<String, dynamic> && response.containsKey('chatMessage')) {
          return ChatMessage.fromJson(response['chatMessage']);
        } else if (response is Map<String, dynamic> && response.containsKey('message')) {
          // If the API returns a success message but no chatMessage, create a temporary one
          return ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'current_user', // This will be replaced by actual user ID
            senderName: 'You',
            senderRole: 'serviceProvider',
            message: message,
            timestamp: DateTime.now(),
            status: 'sent',
            bookingId: bookingId,
          );
        } else {
          throw Exception('Invalid response format: $response');
        }
      } catch (e) {
        currentRetry++;
        log("API Error (attempt $currentRetry): $e");
        
        if (currentRetry >= maxRetries) {
          final errorMessage = NetworkUtils.getErrorMessage(e);
          throw Exception('Failed to send message: $errorMessage');
        }
        
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: currentRetry));
      }
    }
    
    throw Exception('Failed to send message after all retries');
  }

  // Check if chat is available for a booking
  Future<Map<String, dynamic>> checkChatAvailability(String bookingId) async {
    try {
      final response = await apiClient.get('${ApiConstants.getChatHistory}/$bookingId');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to check chat availability: $e');
    }
  }
}
