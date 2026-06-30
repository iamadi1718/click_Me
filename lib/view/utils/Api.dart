class Api {
  static const String baseUrl = "http://103.207.183.10:5000";
  static const String homeUrl = "$baseUrl/api/v1/feed/home";
  static const String storyUrl = "$baseUrl/api/v1/story/feed";
  static const String profileUrl = "$baseUrl/api/v1/users/current-user";
  static const String chatUrl = "$baseUrl/api/v1/chat/threads";
  static const String blockUrl = "$baseUrl/api/v1/users/blocked-list";
  static const String followersUrl =
      "$baseUrl/api/v1/follow/followers/6a33d1ada6d326341a9c10f4";
  static const String followingUrl =
      "$baseUrl/api/v1/follow/following/6a33d1ada6d326341a9c10f4";
  static const String followRequestsUrl =
      "$baseUrl/api/v1/follow/pending-requests";
        static const String reelsUrl =
      "$baseUrl/api/v1/feed/reels";
      static const String postsUrl =
      "$baseUrl/api/v1/post/explore";
      static const String chatMessagesUrl =
      "$baseUrl/api/v1/chat/messages";
}
