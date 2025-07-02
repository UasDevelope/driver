import 'dart:developer';

import 'package:driver/api/api_const.dart';
import 'package:driver/models/profile_model.dart';
import 'package:get_it/get_it.dart';
import '../api/base_api_client.dart';

class ProfileRepository {
  final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();

  Future<ProfileModel> getProfile() async {
    final response = await apiClient.get(ApiConstants.getProfile);

    if (response != null && response['user'] != null) {
      final profile = ProfileModel.fromJson(response);
      log("Parsed ProfileModel: $profile");
      return profile;
    } else {
      throw Exception("Failed to load user profile");
    }
  }


}
