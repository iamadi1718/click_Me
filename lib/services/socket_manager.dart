// import 'dart:async';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:click_me/view/utils/api.dart';
// import 'package:click_me/data/services/local/storage_services.dart';

// class SocketManager {
//   SocketManager._internal();

//   static final SocketManager _instance = SocketManager._internal();

//   static SocketManager get instance => _instance;

//   factory SocketManager() => _instance;

//   late IO.Socket socket;

//   String? currentChatThreadId;

//   bool _initialized = false;

//   bool get connected => socket.connected;

//   //--------------------------------------------------
//   // STREAM CONTROLLERS
//   //--------------------------------------------------

//   final _viewerJoinController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _offerController = StreamController<Map<String, dynamic>>.broadcast();

//   final _answerController = StreamController<Map<String, dynamic>>.broadcast();

//   final _candidateController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _commentController = StreamController<Map<String, dynamic>>.broadcast();

//   final _heartController = StreamController<Map<String, dynamic>>.broadcast();

//   final _viewerCountController = StreamController<int>.broadcast();

//   final _liveEndController = StreamController<Map<String, dynamic>>.broadcast();

//   final _liveStartedController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _liveEndedController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _iceCandidateController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _viewerLeaveController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _chatRefreshController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _userOnlineController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   final _userOfflineController =
//       StreamController<Map<String, dynamic>>.broadcast();
//   final _messageUnreadCountController =
//       StreamController<Map<String, dynamic>>.broadcast();
//   final _notificationUnreadCountController =
//       StreamController<Map<String, dynamic>>.broadcast();

//   //--------------------------------------------------
//   // GETTERS
//   //--------------------------------------------------

//   Stream<Map<String, dynamic>> get onViewerJoin => _viewerJoinController.stream;

//   Stream<Map<String, dynamic>> get onOffer => _offerController.stream;

//   Stream<Map<String, dynamic>> get onAnswer => _answerController.stream;

//   Stream<Map<String, dynamic>> get onCandidate => _candidateController.stream;

//   Stream<Map<String, dynamic>> get onComment => _commentController.stream;

//   Stream<Map<String, dynamic>> get onHeart => _heartController.stream;

//   Stream<int> get onViewerCount => _viewerCountController.stream;

//   Stream<Map<String, dynamic>> get onLiveEnd => _liveEndController.stream;

//   Stream<Map<String, dynamic>> get onLiveStarted =>
//       _liveStartedController.stream;

//   Stream<Map<String, dynamic>> get onLiveEnded => _liveEndedController.stream;

//   Stream<Map<String, dynamic>> get onIceCandidate =>
//       _iceCandidateController.stream;

//   Stream<Map<String, dynamic>> get onViewerLeave =>
//       _viewerLeaveController.stream;

//   Stream<Map<String, dynamic>> get onReceiveMessage => onComment;

//   Stream<Map<String, dynamic>> get onLiveHeart => onHeart;

//   Stream<Map<String, dynamic>> get onChatRefresh =>
//       _chatRefreshController.stream;

//   Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;
//   Stream<Map<String, dynamic>> get onUserOffline =>
//       _userOfflineController.stream;
//   Stream<Map<String, dynamic>> get onMessageUnreadCount =>
//       _messageUnreadCountController.stream;
//   Stream<Map<String, dynamic>> get onNotificationUnreadCount =>
//       _notificationUnreadCountController.stream;

//   //--------------------------------------------------
//   // INIT
//   //--------------------------------------------------

//   void init() {
//     if (_initialized) return;

//     _initialized = true;

//     final token = StorageService.getAccessToken();

//     socket = IO.io(
//       Api.baseUrl,
//       IO.OptionBuilder()
//           .setTransports(["websocket", "polling"])
//           .enableAutoConnect()
//           .enableReconnection()
//           .setReconnectionAttempts(100)
//           .setReconnectionDelay(2000)
//           .setAuth({'token': token})
//           .setQuery({'token': token})
//           .setExtraHeaders({'Authorization': 'Bearer $token'})
//           .build(),
//     );

//     socket.connect();

//     socket.onConnect((_) {
//       print("Socket Connected");
//     });

//     socket.onDisconnect((_) {
//       print("Socket Disconnected");
//     });

//     socket.onConnectError((e) {
//       print("Connect Error $e");
//     });

//     socket.onError((e) {
//       print("Socket Error $e");
//     });

//     //--------------------------------------------------
//     // LISTENERS
//     //--------------------------------------------------
//     // Prevent duplicate listeners
//     socket.off("viewer_join");
//     socket.off("offer");
//     socket.off("answer");
//     socket.off("candidate");
//     socket.off("comment");
//     socket.off("heart");
//     socket.off("viewer_count");
//     socket.off("live_end");
//     socket.off("live_started");
//     socket.off("viewer_leave");
//     socket.off("chat_refresh");
//     socket.off("userOnline");
//     socket.off("userOffline");
//     socket.off("messageUnreadCountUpdated");
//     socket.off("notificationUnreadCountUpdated");
//     socket.off("newLiveComment");
//     socket.off("viewerCountUpdated");

//     //--------------------------------------------------
//     // LISTENERS
//     //--------------------------------------------------

//     socket.on("viewer_join", (data) {
//       _viewerJoinController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("offer", (data) {
//       _offerController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("answer", (data) {
//       _answerController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("candidate", (data) {
//       _candidateController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("comment", (data) {
//       _commentController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("heart", (data) {
//       _heartController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("viewer_count", (count) {
//       _viewerCountController.add(count);
//     });

//     socket.on("live_end", (data) {
//       _liveEndController.add(Map<String, dynamic>.from(data));
//       _liveEndedController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("live_started", (data) {
//       _liveStartedController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("candidate", (data) {
//       _iceCandidateController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("viewer_leave", (data) {
//       _viewerLeaveController.add(Map<String, dynamic>.from(data));
//     });

//     socket.on("chat_refresh", (data) {
//       _chatRefreshController.add(Map<String, dynamic>.from(data ?? {}));
//     });

//     socket.on("userOnline", (data) {
//       if (data != null) {
//         _userOnlineController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     socket.on("userOffline", (data) {
//       if (data != null) {
//         _userOfflineController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     socket.on("messageUnreadCountUpdated", (data) {
//       if (data != null) {
//         _messageUnreadCountController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     socket.on("notificationUnreadCountUpdated", (data) {
//       if (data != null) {
//         _notificationUnreadCountController.add(Map<String, dynamic>.from(data));
//       }
//     });

//     socket.on("newLiveComment", (data) {
//       if (data != null) {
//         // Handle both raw comment object or { comment: {...} } payload
//         if (data is Map &&
//             data.containsKey("comment") &&
//             data["comment"] is Map) {
//           _commentController.add(Map<String, dynamic>.from(data["comment"]));
//         } else if (data is Map) {
//           _commentController.add(Map<String, dynamic>.from(data));
//         }
//       }
//     });

//     socket.on("viewerCountUpdated", (data) {
//       if (data != null) {
//         if (data is Map && data.containsKey("viewerCount")) {
//           _viewerCountController.add(data["viewerCount"] as int);
//         } else if (data is int) {
//           _viewerCountController.add(data);
//         }
//       }
//     });
//   }

//   //--------------------------------------------------
//   // HOST
//   //--------------------------------------------------

//   void hostJoin(String streamId, String hostId) {
//     socket.emit("host_join", {"streamId": streamId, "hostId": hostId});
//   }

//   //--------------------------------------------------
//   // VIEWER
//   //--------------------------------------------------

//   void viewerJoin(String streamId, String viewerId) {
//     socket.emit("viewer_join", {"streamId": streamId, "viewerId": viewerId});
//   }

//   void viewerLeave(String streamId, String viewerId) {
//     socket.emit("viewer_leave", {"streamId": streamId, "viewerId": viewerId});
//   }

//   void joinLive(String streamId, String userId) {
//     print("Joined Room");
//     socket.emit("joinLiveStream", {"streamId": streamId, "userId": userId});
//     viewerJoin(streamId, userId);
//   }

//   void leaveLive(String streamId, String userId) {
//     socket.emit("leaveLiveStream", {"streamId": streamId, "userId": userId});
//     viewerLeave(streamId, userId);
//   }

//   //--------------------------------------------------
//   // OFFER
//   //--------------------------------------------------

//   void sendOffer(Map<String, dynamic> data) {
//     socket.emit("offer", data);
//   }

//   //--------------------------------------------------
//   // ANSWER
//   //--------------------------------------------------

//   void sendAnswer(Map<String, dynamic> data) {
//     socket.emit("answer", data);
//   }

//   //--------------------------------------------------
//   // ICE
//   //--------------------------------------------------

//   void sendCandidate(
//     String streamId,
//     String targetId,
//     Map<String, dynamic> candidate,
//   ) {
//     socket.emit("candidate", {
//       "streamId": streamId,
//       "targetId": targetId,
//       "candidate": candidate,
//     });
//   }

//   void sendIceCandidate(Map<String, dynamic> data) {
//     socket.emit("candidate", data);
//   }

//   //--------------------------------------------------
//   // COMMENT
//   //--------------------------------------------------

//   void sendComment(String streamId, String userId, String text) {
//     socket.emit("comment", {
//       "streamId": streamId,
//       "userId": userId,
//       "text": text,
//     });
//   }

//   //--------------------------------------------------
//   // HEART
//   //--------------------------------------------------

//   void sendHeart(String streamId, String userId) {
//     socket.emit("heart", {"streamId": streamId, "userId": userId});
//   }

//   //--------------------------------------------------
//   // END LIVE
//   //--------------------------------------------------

//   void endLive(String streamId) {
//     socket.emit("live_end", {"streamId": streamId});
//   }

//   void emitLiveEnded(String streamId) {
//     endLive(streamId);
//   }

//   void emitLiveStarted(String streamId, String userId) {
//     // Emitting what backend might expect: startLiveStream or live_started
//     socket.emit("startLiveStream", {
//       "liveId": streamId,
//       "streamId": streamId,
//       "userId": userId,
//     });

//     socket.emit("live_started", {
//       "liveId": streamId,
//       "streamId": streamId,
//       "userId": userId,
//     });
//   }

//   void emitChatRefresh() {
//     socket.emit("chat_refresh", {});
//   }

//   //--------------------------------------------------
//   // DISPOSE
//   //--------------------------------------------------

//   void dispose() {
//     socket.dispose();

//     _viewerJoinController.close();

//     _offerController.close();

//     _answerController.close();

//     _candidateController.close();

//     _commentController.close();

//     _heartController.close();

//     _viewerCountController.close();

//     _liveEndController.close();

//     _liveStartedController.close();

//     _liveEndedController.close();

//     _iceCandidateController.close();

//     _viewerLeaveController.close();

//     _chatRefreshController.close();

//     _userOnlineController.close();

//     _userOfflineController.close();

//     _initialized = false;
//   }
// }
