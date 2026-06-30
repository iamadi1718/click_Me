class Api {
  static const String baseUrl = "http://103.207.183.10:5000";
  static const String signupUrl = "$baseUrl/api/v1/users/register";
  static const String loginUrl = "$baseUrl/api/v1/users/login";
  static const String otpverifyUrl = "$baseUrl/api/v1/users/verify-register";
  static const String forgotUrl = "$baseUrl/api/v1/users/forgot-password";
  static const String AddprofileUrl = "$baseUrl/api/v1/users/complete-profile";
  static const String storyUploadUrl = "$baseUrl/api/v1/story/upload";
  static const String postUrl = "$baseUrl/api/v1/story/feed";
  static const String deleteStoryBaseUrl = "$baseUrl/api/v1/story";

  static const String homeUrl = "$baseUrl/api/v1/feed/home";
  static const String storyUrl = "$baseUrl/api/v1/story/feed";
  static const String profileUrl = "$baseUrl/api/v1/users/current-user";
  static const String chatUrl = "$baseUrl/api/v1/chat/threads";
  static const String blockUrl = "$baseUrl/api/v1/users/blocked-list";
  static const String followersUrl = "$baseUrl/api/v1/follow/followers";
  static const String followingUrl = "$baseUrl/api/v1/follow/following";
  static const String followRequestsUrl =
      "$baseUrl/api/v1/follow/pending-requests";
  static const String reelsUrl = "$baseUrl/api/v1/feed/reels";
  static const String postsUrl = "$baseUrl/api/v1/post/explore";
  static const String chatMessagesUrl = "$baseUrl/api/v1/chat/messages";
}
