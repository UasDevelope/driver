import 'package:driver/api/api_const.dart';
import 'package:driver/api/base_api_client.dart';
import 'package:get_it/get_it.dart';

class AuthRepository {
  final BaseApiClient _apiClient = GetIt.instance<BaseApiClient>();
  Future<Map<String,dynamic>> SignUpUser({
    required String fullName,
    required String contactNumber,
    required String email,
    required String password,
    required String role,
    String? drivingPermitNumber,
    String? certificateNumber,
  }) async {
    final Map<String, dynamic> body = {
      "fullName": fullName,
      "email": email,
      "contactNumber": contactNumber,
      "password": password,
      "role": role,
    };
    if (role == "serviceProvider") {
      if (drivingPermitNumber != null) {
        body['drivingPermitNumber'] = drivingPermitNumber;
      }
      if (certificateNumber != null) {
        body["certificateNumber"] = certificateNumber;
      }
    }
    var response = _apiClient.post(ApiConstants.register, body);
    return response;
  }
}
