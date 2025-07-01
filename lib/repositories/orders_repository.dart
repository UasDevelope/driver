import 'package:driver/models/order.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';

class OrdersRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<List<SimpleBooking>> getBookings(String endPont) async {
    final response = await apiClient.get(endPont);
    if (response != null && response['bookings'] is List) {
      final bookingsJson = response['bookings'] as List<dynamic>;
      return bookingsJson
          .map((item) => SimpleBooking.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
