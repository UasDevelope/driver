import 'dart:convert';
import 'dart:developer';
import 'package:driver/api/api_exception.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/services/local.dart';
import 'package:driver/utils/server_health_checker.dart';
import 'package:http/http.dart' as http;

class ApiClientImp implements BaseApiClient {
  final http.Client _client;

  ApiClientImp(this._client);

  @override
  Future<dynamic> get(String endpoint, {bool auth = true,Map<String, dynamic>? queryParameters,}) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final url = Uri.parse(endpoint).replace(queryParameters: queryParameters);
    log("[GET URL] $url");
    if (auth && token == null) {
      log("No token found, proceeding unauthenticated");
    }

    try {
      final response = await _client.get(url, headers: _header(token ?? "")).timeout(
        const Duration(seconds: 30), // 30 second timeout
        onTimeout: () {
          log("⚠️ Request timeout for GET $url");
          throw ApiException(message: "Request timeout. Please check your internet connection and try again.");
        },
      );
      log("[RESPONSE ${response.statusCode}] ${response.body}");
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      
      log("❌ Network error during GET request: $e");
      
      // Check if it's a connection refused error and try to switch servers
      if (e.toString().contains("Connection refused") || 
          e.toString().contains("SocketException")) {
        log("🔄 Connection refused detected, attempting server switch...");
        
        try {
          await ServerHealthChecker.autoSwitchToBestServer();
          
          // If we switched servers, retry the request
          if (ServerHealthChecker.isAnyServerAvailable) {
            log("🔄 Retrying request with new server...");
            final newUrl = endpoint.replaceFirst(
              Uri.parse(endpoint).origin,
              Uri.parse(ServerHealthChecker.currentServerUrl).origin,
            );
            
            final retryResponse = await _client.get(
              Uri.parse(newUrl),
              headers: _header(token ?? ""),
            ).timeout(const Duration(seconds: 30));
            
            log("[RETRY RESPONSE ${retryResponse.statusCode}] ${retryResponse.body}");
            return handleResponse(retryResponse);
          }
        } catch (retryError) {
          log("❌ Retry failed: $retryError");
        }
      }
      
      throw ApiException(message: "Network error. Please check your internet connection and try again.");
    }
  }

  @override
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final url = Uri.parse(endpoint);

    log("[POST] $url\nBody: ${jsonEncode(body)}");
    if (auth && token == null) {
      log("No token found, proceeding unauthenticated");
    }
    
    try {
      final response = await _client.post(
        url,
        headers: _header(token ?? ""),
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30), // 30 second timeout
        onTimeout: () {
          log("⚠️ Request timeout for POST $url");
          throw ApiException(message: "Request timeout. Please check your internet connection and try again.");
        },
      );
      log("[RESPONSE ${response.statusCode}] ${response.body}");
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      
      log("❌ Network error during POST request: $e");
      
      // Check if it's a connection refused error and try to switch servers
      if (e.toString().contains("Connection refused") || 
          e.toString().contains("SocketException")) {
        log("🔄 Connection refused detected, attempting server switch...");
        
        try {
          await ServerHealthChecker.autoSwitchToBestServer();
          
          // If we switched servers, retry the request
          if (ServerHealthChecker.isAnyServerAvailable) {
            log("🔄 Retrying request with new server...");
            final newUrl = endpoint.replaceFirst(
              Uri.parse(endpoint).origin,
              Uri.parse(ServerHealthChecker.currentServerUrl).origin,
            );
            
            final retryResponse = await _client.post(
              Uri.parse(newUrl),
              headers: _header(token ?? ""),
              body: jsonEncode(body),
            ).timeout(const Duration(seconds: 30));
            
            log("[RETRY RESPONSE ${retryResponse.statusCode}] ${retryResponse.body}");
            return handleResponse(retryResponse);
          }
        } catch (retryError) {
          log("❌ Retry failed: $retryError");
        }
      }
      
      throw ApiException(message: "Network error. Please check your internet connection and try again.");
    }
  }

  @override
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final url = Uri.parse(endpoint);

    log("[PUT] $url\nBody: ${jsonEncode(body)}");
    if (auth && token == null) {
      log("No token found, proceeding unauthenticated");
    }
    
    try {
      final response = await _client.put(
        url,
        headers: _header(token ?? ""),
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 30), // 30 second timeout
        onTimeout: () {
          log("⚠️ Request timeout for PUT $url");
          throw ApiException(message: "Request timeout. Please check your internet connection and try again.");
        },
      );
      log("[RESPONSE ${response.statusCode}] ${response.body}");
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      log("❌ Network error during PUT request: $e");
      throw ApiException(message: "Network error. Please check your internet connection and try again.");
    }
  }

  @override
  Future<dynamic> delete(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final url = Uri.parse(endpoint);

    log("[DELETE] $url\nBody: ${jsonEncode(body)}");
    if (auth && token == null) {
      log("No token found, proceeding unauthenticated");
    }
    
    try {
      final request =
          http.Request("DELETE", url)
            ..headers.addAll(_header(token ?? ""))
            ..body = jsonEncode(body);

      final streamedResponse = await _client.send(request).timeout(
        const Duration(seconds: 30), // 30 second timeout
        onTimeout: () {
          log("⚠️ Request timeout for DELETE $url");
          throw ApiException(message: "Request timeout. Please check your internet connection and try again.");
        },
      );
      final response = await http.Response.fromStream(streamedResponse);
      log("[RESPONSE ${response.statusCode}] ${response.body}");
      return handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      log("❌ Network error during DELETE request: $e");
      throw ApiException(message: "Network error. Please check your internet connection and try again.");
    }
  }

  Map<String, String> _header(String token) {
    return {
      "Content-Type": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  dynamic handleResponse(http.Response response) {
    dynamic body;
    try {
      body = json.decode(response.body);
    } catch (e) {
      log("❌ JSON parsing error: $e");
      log("❌ Response body: ${response.body}");
      throw ApiException(message: "Server returned invalid data. Please try again.");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 400:
        final message = body is Map ? (body["message"] ?? "Invalid request data") : "Bad Request";
        throw BadRequestException(message);
      case 401:
        throw UnauthorizedException();
      case 403:
        throw ApiException(message: "Access denied. Please check your permissions.");
      case 404:
        throw NotFoundException();
      case 409:
        final message = body is Map ? (body["message"] ?? "Resource already exists") : "Conflict";
        throw ApiException(message: message);
      case 422:
        final message = body is Map ? (body["message"] ?? "Validation error") : "Invalid data";
        throw ApiException(message: message);
      case 500:
        throw InternalServerError();
      case 502:
      case 503:
      case 504:
        throw ApiException(message: "Server is temporarily unavailable. Please try again later.");
      default:
        final message = body is Map ? (body["message"] ?? "Unknown error") : "Unexpected error";
        throw ApiException(message: "$message (${response.statusCode})");
    }
  }
}
