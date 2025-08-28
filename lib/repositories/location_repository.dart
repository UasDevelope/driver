import 'package:get_it/get_it.dart';
import '../api/api_const.dart';
import '../api/base_api_client.dart';
import '../utils/network_utils.dart';

class LocationRepository {
  final BaseApiClient _apiClient = GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      final body = {
        "latitude": latitude,
        "longitude": longitude,
        if (locationName != null) "locationName": locationName,
      };

      final response = await _apiClient.put(
        ApiConstants.updateLocation,
        body,
      );

      return response;
    } catch (e) {
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
