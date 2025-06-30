import 'package:driver/api/api_const.dart';
import 'package:driver/models/EarningsModel.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';

class EarningsRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
  Future<EarningsModel> getEarnings() async {
    final response = await apiClient.get(ApiConstants.fetchBooking);
    return EarningsModel.fromJson(response);
  }

}
