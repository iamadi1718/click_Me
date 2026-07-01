import 'package:click_me/data/services/api_services.dart';
import 'package:click_me/data/services/network/api_exception.dart';
import 'package:click_me/view/utils/api.dart';

class ForgotRepository {
  final ApiService _api = ApiService.instance;

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await _api.post(Api.forgotUrl, body: {"email": email});

    if (response is Map<String, dynamic>) {
      return response;
    }
    throw ApiException(message: "Invalid API response structure");
  }
}

