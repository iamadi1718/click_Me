import 'package:click_me/Models/forgotpass_model/forgotpass_model.dart';
import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/data/services/network/api_exception.dart';
import 'package:click_me/view/utils/api.dart';

class ForgotRepository {
  final ApiService _api = ApiService.instance;

  Future<ForgotPassModel> forgotPassword({required String email}) async {
    final response = await _api.post(Api.forgotUrl, body: {"email": email});

    if (response is Map<String, dynamic>) {
      return ForgotPassModel.fromJson(response);
    }
    throw ApiException(message: "Invalid API response structure");
  }
}


