import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/Models/Homemodel/authmodel/auth_response_model.dart';
import 'package:click_me/view/utils/api.dart';

class LoginRepository {
  final ApiService _api = ApiService.instance;

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      Api.loginUrl,
      body: {"email": email, "password": password},
    );

    return AuthResponseModel.fromJson(response);
  }
}

