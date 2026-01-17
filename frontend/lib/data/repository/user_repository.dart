import 'dart:io';

import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/response/auth_response.dart';
import 'package:frontend/data/usecase/response/user_response.dart';

class UserRepository {
  final HttpService httpService;
  UserRepository(this.httpService);

  Future<UserResponse> getProfile() async {
    final response = await httpService.get('user');
    return UserResponse.fromJson(response.body);
  }

  Future<UserResponse> updateProfile({
    required String name,
    required String phone,
    required String alamat,
    File? imageFile,
  }) async {
    Map<String, String> fields = {
      'name': name,
      'phone_number': phone,
      'alamat_lengkap': alamat,
    };

    final response = await httpService.postWithFile(
      'user/update',
      fields,
      imageFile,
      'profile_picture',
    );
    return UserResponse.fromJson(response.body);
  }
}
