import 'dart:convert';
import 'package:click_me/data/services/local/storage_services.dart';
import 'package:click_me/view/utils/api.dart';
import 'package:http/http.dart' as http;

class LiveCheckService {
  /// Returns live stream data (streamId, title) if the user is currently live.
  /// Response structure: { data: { liveStreams: [ { _id, status, title, ... } ] } }
  /// Returns null if user is not live or on any error.
  Future<Map<String, String>?> getUserActiveLive(String userId) async {
    try {
      final token = StorageService.getAccessToken();
      final url = '${Api.userActiveLiveUrl}/$userId';

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        if (data == null) return null;

        // data.liveStreams is a list — pick the first one with status == "live"
        final streams = data['liveStreams'];
        if (streams == null || streams is! List || streams.isEmpty) return null;

        final liveStream = streams.firstWhere(
          (s) => s['status'] == 'live',
          orElse: () => null,
        );

        if (liveStream == null) return null;

        return {
          'streamId': liveStream['_id']?.toString() ?? '',
          'title': liveStream['title']?.toString() ?? 'Live Stream',
          'streamerName': '', // streamer name fetched from profile separately
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

