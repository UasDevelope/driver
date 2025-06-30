import 'package:driver/api/api_const.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';
import '../models/booking.dart';

class OrdersRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<List<BookingModel>> getBookings() async {
    final response = await apiClient.get(ApiConstants.fetchBooking);
    final bookingsJson = response['bookings'] as List<dynamic>;
    return bookingsJson
        .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

}
