import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../APIFunctions/api_globals.dart';
import 'socket.dart';

class SocketListener extends Socket {
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel socket;
  bool _isConnected = false;
  late String name;
  late String passcode;

  SocketListener(String userName, String passCode) {
    name = userName;
    passcode = passCode;
    _init();
  }

  _init() {
    connect();
  }

  void disconnect() {
    socket.sink.close();
    buttonNotifier.value = false;
    _isConnected = false;
  }

  Future<void> connect() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080/concert/listener?name=$name=passcode=$passcode'));
    _isConnected = true;
  }
}
