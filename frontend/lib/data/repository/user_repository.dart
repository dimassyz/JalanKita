import 'dart:io';

import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/response/user_response.dart';
import 'package:frontend/data/usecase/request/update_profile_request.dart';

class UserRepository {
  final HttpService httpService;
  UserRepository(this.httpService);

  Future<UserResponse> getProfile() async {
    final response = await httpService.get('user');
    return UserResponse.fromJson(response.body);
  }

  Future<UserResponse> updateProfile(
    UpdateProfileRequest request,
    File? imageFile,
  ) async {
    final response = await httpService.postWithFile(
      'user/update',
      request.toMap(),
      imageFile,
      'profile_picture',
    );
    return UserResponse.fromJson(response.body);
  }
}
