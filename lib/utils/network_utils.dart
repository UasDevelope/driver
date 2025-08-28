import 'dart:developer';

class NetworkUtils {
  /// Handles common network errors and provides user-friendly messages
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains("connection refused") || errorString.contains("socketexception")) {
      return "Server is currently unavailable. We're trying to connect to an alternative server. Please try again in a moment.";
    } else if (errorString.contains("timeout")) {
      return "Request timed out. Please check your internet connection and try again.";
    } else if (errorString.contains("network error")) {
      return "Network error. Please check your internet connection and try again.";
    } else if (errorString.contains("401")) {
      return "You need to be logged in to perform this action.";
    } else if (errorString.contains("403")) {
      return "Access denied. Please check your permissions.";
    } else if (errorString.contains("404")) {
      return "Resource not found. Please try again.";
    } else if (errorString.contains("409")) {
      return "Resource already exists. Please try a different option.";
    } else if (errorString.contains("422")) {
      return "Invalid data provided. Please check your information and try again.";
    } else if (errorString.contains("500")) {
      return "Server error. Please try again later.";
    } else if (errorString.contains("502") || errorString.contains("503") || errorString.contains("504")) {
      return "Server is temporarily unavailable. Please try again later.";
    } else if (errorString.contains("socket")) {
      return "Connection failed. Please check your internet connection and try again.";
    } else if (errorString.contains("handshake")) {
      return "Secure connection failed. Please try again.";
    } else {
      return "An unexpected error occurred. Please try again later.";
    }
  }

  /// Retry mechanism for API calls
  static Future<T> retryApiCall<T>({
    required Future<T> Function() apiCall,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        attempt++;
        log("⚠️ API call failed (attempt $attempt/$maxRetries): $e");
        
        if (attempt >= maxRetries) {
          log("❌ All retry attempts failed");
          rethrow;
        }
        
        // Wait before retrying (exponential backoff)
        await Future.delayed(delay);
        delay = Duration(seconds: delay.inSeconds * 2);
      }
    }
    
    throw Exception("Failed after $maxRetries attempts");
  }

  /// Check if error is retryable
  static bool isRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Don't retry on client errors (4xx) except 408, 429
    if (errorString.contains("400") || errorString.contains("401") || 
        errorString.contains("403") || errorString.contains("404") ||
        errorString.contains("409") || errorString.contains("422")) {
      return false;
    }
    
    // Retry on server errors (5xx) and network issues
    return errorString.contains("500") || errorString.contains("502") ||
           errorString.contains("503") || errorString.contains("504") ||
           errorString.contains("timeout") || errorString.contains("network error") ||
           errorString.contains("socket") || errorString.contains("handshake");
  }

  /// Get appropriate retry count based on error type
  static int getRetryCount(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains("timeout")) {
      return 2; // Retry timeouts fewer times
    } else if (errorString.contains("500") || errorString.contains("502") ||
               errorString.contains("503") || errorString.contains("504")) {
      return 3; // Retry server errors more times
    } else {
      return 1; // Default retry count
    }
  }
}
