import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/Models/Homemodel/authmodel/auth_response_model.dart';
import 'package:click_me/view/utils/api.dart';

class OtpVerifyRepository {
  final ApiService _api = ApiService.instance;

  Future<AuthResponseModel> verifyOtp({
    required String emailOrPhone,
    required String otp,
  }) async {
    final Map<String, dynamic> body = {
      "identifier": emailOrPhone,
      "otp": otp,
    };

    print("RAW OTP VERIFY BODY: $body");
    final response = await _api.post(
      Api.otpverifyUrl,
      body: body,
    );
    print("RAW OTP VERIFY RESPONSE: $response");

    return AuthResponseModel.fromJson(response);
  }
}






