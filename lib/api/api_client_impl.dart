import 'dart:convert';
import 'dart:developer';
import 'package:driver/api/api_exception.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/services/local.dart';
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

    final response = await _client.get(url, headers: _header(token ?? ""));
    log("[RESPONSE ${response.statusCode}] ${response.body}");
    return handleResponse(response);
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
    final response = await _client.post(
      url,
      headers: _header(token ?? ""),
      body: jsonEncode(body),
    );
    log("[RESPONSE ${response.statusCode}] ${response.body}");
    return handleResponse(response);
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
    final response = await _client.put(
      url,
      headers: _header(token ?? ""),
      body: jsonEncode(body),
    );
    log("[RESPONSE ${response.statusCode}] ${response.body}");
    return handleResponse(response);
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
    final request =
        http.Request("DELETE", url)
          ..headers.addAll(_header(token ?? ""))
          ..body = jsonEncode(body);

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    log("[RESPONSE ${response.statusCode}] ${response.body}");
    return handleResponse(response);
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
      throw ApiException(message: "Invalid JSON: ${response.body}");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 400:
        throw BadRequestException(body["message"] ?? "Bad Request");
      case 401:
        throw UnauthorizedException();
      case 404:
        throw NotFoundException();
      case 500:
        throw InternalServerError();
      default:
        throw ApiException(
          message:
              "Unexpected error: ${response.statusCode} || ${response.body}",
        );
    }
  }
}
