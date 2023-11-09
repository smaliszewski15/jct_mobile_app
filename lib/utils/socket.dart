import 'package:web_socket_channel/web_socket_channel.dart';
import '../APIFunctions/api_globals.dart';

abstract class Socket {
  late WebSocketChannel socket;
  bool _isConnected = false;
  late String name;
  late String passcode;
}

enum SocketType {
  listener,
  performer,
  maestro
}
