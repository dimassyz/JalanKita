import 'package:frontend/data/service/http_service.dart';
import 'package:frontend/data/usecase/request/register_request.dart';
import 'package:frontend/data/usecase/response/auth_response.dart';

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
}
