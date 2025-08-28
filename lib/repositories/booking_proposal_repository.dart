import 'package:get_it/get_it.dart';
import '../api/api_const.dart';
import '../api/base_api_client.dart';
import '../models/booking_proposal_model.dart';
import '../utils/network_utils.dart';

class BookingProposalRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<Map<String, dynamic>> submitBookingProposal(
    BookingProposalModel proposal,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.submitProposal,
        proposal.toJson(),
      );
      return response;
    } catch (e) {
      final errorMessage = NetworkUtils.getErrorMessage(e);
      throw Exception(errorMessage);
    }
  }
}
