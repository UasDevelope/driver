import 'package:driver/api/api_const.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:driver/models/auth_model.dart';
import '../api/service_locator.dart';
import '../services/local.dart';
import '../utils/network_utils.dart';

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

      final response = await apiClient.post(ApiConstants.register, body, auth: false);
      if (response.containsKey('token')) {
        await LocalStorage.storeString(
          LocalStorage.AcessToken,
          response['token'],
        );
      }
      return response;
    } catch (e) {
      // Use NetworkUtils for consistent error handling
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> body = {"email": email, "password": password};
      final response = await apiClient.post(ApiConstants.login, body, auth: false);
      if (response.containsKey('token')) {
        await LocalStorage.storeString(
          LocalStorage.AcessToken,
          response['token'],
        );
        return response;
      } else {
        throw Exception('Login failed: token not found in response');
      }
    } catch (e) {
      // Use NetworkUtils for consistent error handling
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await apiClient.delete(ApiConstants.deleteAccount, {}, auth: true);
      
      // Clear local storage after successful account deletion
      await LocalStorage.storeString(LocalStorage.AcessToken, '');
      
      return response;
    } catch (e) {
      // Use NetworkUtils for consistent error handling
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
