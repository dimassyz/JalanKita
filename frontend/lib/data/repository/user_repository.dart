import 'dart:io';

import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/response/auth_response.dart';

class UserRepository {
  final HttpService httpService;
  UserRepository(this.httpService);

  Future<AuthResponse> getProfile() async {
    final response = await httpService.get('user');
    return AuthResponse.fromJson(response.body);
  }

  Future<AuthResponse> updateProfile({
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
    return AuthResponse.fromJson(response.body);
  }
}
