import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/Models/Homemodel/authmodel/auth_response_model.dart';
import 'package:click_me/view/utils/api.dart';

class AuthRepository {
  final ApiService _api = ApiService.instance;

  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? gender,
    String? dob,
  }) async {
    final response = await _api.post(
      Api.signupUrl,
      body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "phone": phone,
        "gender": gender,
        "dob": dob,
      },
    );

    print("RAW REGISTER RESPONSE: $response");

    return AuthResponseModel.fromJson(response);
  }
}
