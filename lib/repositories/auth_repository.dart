import 'package:driver/api/api_const.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/models/auth_model.dart';
import '../api/service_locator.dart';
import '../services/local.dart';

class AuthRepository {
  final BaseApiClient apiClient = sl<BaseApiClient>();

  Future<Map<String, dynamic>> signUpUser({
    required AuthModel authModel,
  }) async {
    try {
      final Map<String, dynamic> body = {
        "fullName": authModel.fullName,
        "email": authModel.email,
        "contactNumber": authModel.contactNumber,
        "password": authModel.password,
        "role": authModel.role,
        "drivingPermitNumber": authModel.drivingPermitNumber,
        "certificateNumber": authModel.certificateNumber,
      };
      if (authModel.role != "serviceProvider") {
        body.removeWhere((key, value) => value == null);
      }

      final response = await apiClient.post(ApiConstants.register, body);
      if (response.containsKey('token')) {
        await LocalStorage.storeString(
          LocalStorage.AcessToken,
          response['token'],
        );
      }
      return response;
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {"email": email, "password": password};
    final response = await apiClient.post(ApiConstants.login, body, auth: true);
    if (response.containsKey('token')) {
      await LocalStorage.storeString(
        LocalStorage.AcessToken,
        response['token'],
      );
      return response;
    } else {
      throw Exception('Login failed: token not found in response');
    }
  }
}
