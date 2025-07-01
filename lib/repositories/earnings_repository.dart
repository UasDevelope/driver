import 'package:driver/api/api_const.dart';
import 'package:driver/models/EarningsModel.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';

class EarningsRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
  Future<EarningsModel> getEarnings({
    String? startDate,
    String? endDate,
    String groupBy = 'day',
  }) async {
    final response = await apiClient.get(
      ApiConstants.fetchEarnings,
      queryParameters: {
        'startDate': startDate?? '',
        'endDate': endDate ?? '',
        'groupBy': groupBy,
      },
    );
    return EarningsModel.fromJson(response);
  }

}
