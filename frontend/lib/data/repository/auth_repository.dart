import 'dart:convert';

import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/request/login_request.dart';
import 'package:frontend/data/usecase/request/register_request.dart';
import 'package:frontend/data/usecase/response/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final HttpService httpService;

  AuthRepository(this.httpService);

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await httpService.post('register', request.toMap());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = AuthResponse.fromJson(response.body);
      return responseData;
    } else {
      final errorResponse = AuthResponse.fromJson(response.body);
      return errorResponse;
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    print('DEBUG: Mencoba login ke URL: endpoint login'); 
    print('DEBUG: Data terkirim: ${request.toMap()}');
    final response = await httpService.post('login', request.toMap());
    final authResponse = AuthResponse.fromJson(response.body);

    if (response.statusCode == 200 && authResponse.accessToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.accessToken!);
      await prefs.setBool('is_login', true);

      if (authResponse.data != null) {
        await prefs.setString('user_name', authResponse.data!.username ?? '');
      }
    }
    return authResponse;
  }
}
