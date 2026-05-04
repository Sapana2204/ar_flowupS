import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../constants/appUrls.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;
  String? _userId;

  /// CONNECT SOCKET
  void connect(String userId) {
    _userId = userId;

    if (socket != null && socket!.connected) return;

    socket = IO.io(
      AppUrls.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io')
          .enableReconnection()
          .enableForceNew()
          .build(),
    );

    socket!.connect();

    /// 🔥 Debug all events
    socket!.onAny((event, data) {
      print("📡 EVENT => $event | DATA => $data");
    });

    socket!.onConnect((_) {
      print("✅ Connected: ${socket!.id}");

      /// 🔥 JOIN ROOM
      socket!.emit("join_room", _userId);
      print("📤 join_room sent: $_userId");
    });

    /// ✅ ADD THIS HERE 👇
    socket!.on("room_joined", (data) {
      print("🏠 ROOM JOINED CONFIRMED: $data");
    });

    /// 🔁 Reconnect fix
    socket!.onReconnect((_) {
      print("🔄 Reconnected");

      socket!.emit("join_room", _userId);
      print("📤 Re-joined room: $_userId");
    });

    socket!.onDisconnect((_) {
      print("❌ Disconnected");
    });

    socket!.onConnectError((err) {
      print("❌ Connect Error: $err");
    });

    socket!.onError((err) {
      print("❌ Socket Error: $err");
    });
  }

  /// 🔔 LISTEN NOTIFICATION
  void listenNotification(Function(dynamic data) onData) {
    if (socket == null) {
      print("❌ Socket not initialized yet");
      return;
    }

    socket!.off("new_notification");

    socket!.on("new_notification", (data) {
      print("📩 Notification Received: $data");
      onData(data);
    });
  }

  /// ❌ DISCONNECT
  void disconnect() {
    socket?.disconnect();
    socket = null;
    print("🛑 Socket Disconnected");
  }
}