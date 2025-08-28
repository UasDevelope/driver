import 'package:driver/api/api_const.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';
import '../models/recent_orders_model.dart';
import '../utils/network_utils.dart';

class RecentOrdersRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
  Future<RecentOrdersModel> getRecentOrders() async {
    try {
      final response = await apiClient.get(
        ApiConstants.fetchRecentOrders,
      );
      return RecentOrdersModel.fromJson(response);
    } catch (e) {
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

}
