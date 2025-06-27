abstract class BaseApiClient {
  Future<dynamic> get(String endopint);
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {bool auth});
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {bool auth});
  Future<dynamic> delete(String endpon, Map<String, dynamic> body, {bool auth});
}
