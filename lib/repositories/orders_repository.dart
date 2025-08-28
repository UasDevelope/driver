import 'package:driver/models/order.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';
import '../utils/network_utils.dart';

class OrdersRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<List<OrdersModel>> getBookings(String endPont) async {
    try {
      final response = await apiClient.get(endPont);
      if (response != null && response['bookings'] is List) {
        final bookingsJson = response['bookings'] as List<dynamic>;
        return bookingsJson
            .map((item) => OrdersModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
