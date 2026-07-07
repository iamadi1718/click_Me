import 'dart:async';
import 'dart:convert';
import 'package:click_me/view/utils/api.dart';
import 'package:get/get.dart';

import 'package:click_me/data/services/local/storage_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  SocketManager._internal();
  static SocketManager get instance => _instance;

  IO.Socket? socket;

  // Connection State Rx
  final isConnected = false.obs;
  final isConnecting = false.obs;

  // Active Session Tracking for Auto-Rejoin
  String? _activeStreamId;
  String? _activeUserId;
  bool _isActiveHost = false;
  String? currentChatThreadId;

  final _userOnlineController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _userOfflineController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _messageUnreadCountController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _notificationUnreadCountController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onUserOnline => _userOnlineController.stream;

  Stream<Map<String, dynamic>> get onUserOffline =>
      _userOfflineController.stream;

  Stream<Map<String, dynamic>> get onMessageUnreadCount =>
      _messageUnreadCountController.stream;

  Stream<Map<String, dynamic>> get onNotificationUnreadCount =>
      _notificationUnreadCountController.stream;

  // Queue for early emits before connection
  final List<Map<String, dynamic>> _emitQueue = [];

  // Streams for UI updates
  final _liveStartedController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onLiveStarted =>
      _liveStartedController.stream;

  final _liveEndedController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onLiveEnded => _liveEndedController.stream;

  final _viewerJoinController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onViewerJoin => _viewerJoinController.stream;

  final _viewerLeaveController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onViewerLeave =>
      _viewerLeaveController.stream;

  final _viewerCountController = StreamController<int>.broadcast();
  Stream<int> get onViewerCount => _viewerCountController.stream;

  final _receiveMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onReceiveMessage =>
      _receiveMessageController.stream;

  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onTyping => _typingController.stream;

  final _liveLikeController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onLiveLike => _liveLikeController.stream;

  final _liveHeartController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onLiveHeart => _liveHeartController.stream;

  final _liveReactionController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onLiveReaction =>
      _liveReactionController.stream;

  // WebRTC Signaling Streams
  final _offerController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onOffer => _offerController.stream;

  final _answerController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onAnswer => _answerController.stream;

  final _iceCandidateController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onIceCandidate =>
      _iceCandidateController.stream;
  final _callAcceptedController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onCallAccepted =>
      _callAcceptedController.stream;
  final _callEndedController =
    StreamController<Map<String, dynamic>>.broadcast();

Stream<Map<String, dynamic>> get onCallEnded =>
    _callEndedController.stream;
  // Incoming Call Stream
  final _incomingCallController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onIncomingCall =>
      _incomingCallController.stream;

  void init() {
    print("SocketManager.init() called");
    final token = StorageService.getAccessToken();

    if (socket != null) {
      if (socket?.connected == true) return;
      socket!.disconnect();
      socket!.clearListeners();
      socket = null;
    }

    isConnecting.value = true;
    print(
      "SocketManager: Initializing connection to ${Api.baseUrl} with token: $token",
    );

    socket = IO.io(
      Api.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableForceNew()
          .setReconnectionDelay(2000)
          .setReconnectionAttempts(10)
          .setAuth({'token': token})
          .setQuery({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket!.onAny((event, data) {
      if (event != 'ping' && event != 'pong') {
        // Avoid heartbeat spam
        print("[Socket.IO EVENT] $event: $data");
      }
    });

    socket!.onConnect((_) {
      print("SocketManager: Connected successfully");
      isConnected.value = true;
      isConnecting.value = false;

      // Auto-Rejoin Room Recovery
      if (_activeStreamId != null && _activeUserId != null) {
        print(
          "[DEBUG SocketManager] Auto-rejoining active room $_activeStreamId",
        );
        if (_isActiveHost) {
          socket?.emit('live_started', {'streamId': _activeStreamId});
        }
        socket?.emit('join_live', {
          'streamId': _activeStreamId,
          'userId': _activeUserId,
        });
      }

      // Flush queue
      for (var task in _emitQueue) {
        socket?.emit(task['event'] as String, task['data']);
      }
      _emitQueue.clear();
    });

    socket!.onDisconnect((_) {
      print("SocketManager: Disconnected");
      isConnected.value = false;
      isConnecting.value = false;
    });

    socket!.onConnectError((err) {
      print("SocketManager Connect Error: $err");
      isConnecting.value = false;
      isConnected.value = false;
    });

    socket!.onError((err) {
      print("SocketManager Error: $err");
      isConnected.value = false;
      isConnecting.value = false;
    });

    socket!.connect();

    // Safe parsing helper
    Map<String, dynamic> parseData(dynamic data) {
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      if (data is String) {
        try {
          final decoded = json.decode(data);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {}
      }
      return {};
    }

    void handleAccepted(dynamic data) {
  print("######## call:accepted RECEIVED ########");
  print(data);

  _callAcceptedController.add(parseData(data));
}

    socket!.on("callAccepted", handleAccepted);
    socket!.on("call:accepted", handleAccepted);

    // Bind Listeners
    socket!.on(
      'live_started',
      (data) => _liveStartedController.add(parseData(data)),
    );
    socket!.on(
      'live_ended',
      (data) => _liveEndedController.add(parseData(data)),
    );
    socket!.on(
      'viewer_join',
      (data) => _viewerJoinController.add(parseData(data)),
    );
    socket!.on(
      'viewer_leave',
      (data) => _viewerLeaveController.add(parseData(data)),
    );

    socket!.on('viewer_count_updated', (data) {
      if (data is Map && data['count'] != null) {
        _viewerCountController.add(int.tryParse(data['count'].toString()) ?? 0);
      } else if (data is int) {
        _viewerCountController.add(data);
      } else if (data is String) {
        _viewerCountController.add(int.tryParse(data) ?? 0);
      }
    });
    socket!.on("userOnline", (data) {
      _userOnlineController.add(parseData(data));
    });

    socket!.on("userOffline", (data) {
      _userOfflineController.add(parseData(data));
    });

    socket!.on("messageUnreadCountUpdated", (data) {
      _messageUnreadCountController.add(parseData(data));
    });

    socket!.on("notificationUnreadCountUpdated", (data) {
      _notificationUnreadCountController.add(parseData(data));
    });

    socket!.on(
      'receive_message',
      (data) => _receiveMessageController.add(parseData(data)),
    );
    socket!.on(
      'new_message',
      (data) => _receiveMessageController.add(parseData(data)),
    );
    socket!.on(
      'new_comment',
      (data) => _receiveMessageController.add(parseData(data)),
    );
    socket!.on(
      'comment',
      (data) => _receiveMessageController.add(parseData(data)),
    );
    socket!.on('typing', (data) => _typingController.add(parseData(data)));

    // Interaction State
    socket!.on('live_like', (data) => _liveLikeController.add(parseData(data)));
    socket!.on(
      'live_heart',
      (data) => _liveHeartController.add(parseData(data)),
    );
    socket!.on(
      'live_reaction',
      (data) => _liveReactionController.add(parseData(data)),
    );

    // WebRTC Signaling
    socket!.on('offer', (data) => _offerController.add(parseData(data)));
    socket!.on('answer', (data) => _answerController.add(parseData(data)));
    socket!.on(
      'iceCandidate',
      (data) => _iceCandidateController.add(parseData(data)),
    );
    socket!.on("callEnded", (data) {
  print("========== CALL ENDED ==========");
  print(data);

  _callEndedController.add(parseData(data));
});
    socket!.on("incomingCall", (data) {
      print("========== Incoming Call ==========");
      print(data);

      final callData = parseData(data);

      _incomingCallController.add(callData);
    });
  }

  // ================= Incoming Call =================

  // --- Emission Methods ---

  void _safeEmit(String event, dynamic data) {
    if (isConnected.value && socket?.connected == true) {
      socket?.emit(event, data);
    } else {
      print("[DEBUG SocketManager] Queueing $event (Not connected yet)");
      _emitQueue.add({'event': event, 'data': data});
    }
  }

  void emitChatRefresh() {
    _safeEmit("chat_refresh", {});
  }

  void hostJoin(String streamId, String hostId) {
    _safeEmit("host_join", {"streamId": streamId, "hostId": hostId});
  }

  Future<dynamic> emitWithAck(String event, dynamic data) {
    final completer = Completer<dynamic>();
    if (isConnected.value && socket?.connected == true) {
      socket?.emitWithAck(
        event,
        data,
        ack: (response) {
          completer.complete(response);
        },
      );
    } else {
      completer.completeError("Socket not connected");
    }
    return completer.future;
  }

  void emitLiveStarted(String streamId) {
    _activeStreamId = streamId;
    _isActiveHost = true;
    _safeEmit('live_started', {'streamId': streamId});
  }

  void emitLiveEnded(String streamId) {
    _activeStreamId = null;
    _activeUserId = null;
    _isActiveHost = false;
    _safeEmit('live_ended', {'streamId': streamId});
  }

  void joinLive(String streamId, String userId) {
    _activeStreamId = streamId;
    _activeUserId = userId;
    _safeEmit('join_live', {'streamId': streamId, 'userId': userId});
  }

  void leaveLive(String streamId, String userId) {
    _activeStreamId = null;
    _activeUserId = null;
    _isActiveHost = false;
    _safeEmit('leave_live', {'streamId': streamId, 'userId': userId});
  }

  void sendMessage(String streamId, String userId, String message) => _safeEmit(
    'send_message',
    {'streamId': streamId, 'userId': userId, 'message': message},
  );

  void sendLike(String streamId, String userId) =>
      _safeEmit('live_like', {'streamId': streamId, 'userId': userId});

  void sendHeart(String streamId, String userId) =>
      _safeEmit('live_heart', {'streamId': streamId, 'userId': userId});

  // --- WebRTC Emission Methods ---
  void sendOffer(Map<String, dynamic> data) => _safeEmit('offer', data);
  void sendAnswer(Map<String, dynamic> data) => _safeEmit('answer', data);
  void sendIceCandidate(Map<String, dynamic> data) =>
      _safeEmit('iceCandidate', data);

  void dispose() {
    _incomingCallController.close();
    _callAcceptedController.close();
    _callEndedController.close();
    _activeStreamId = null;
    _activeUserId = null;
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    isConnected.value = false;
  }
}
