import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../APIFunctions/api_globals.dart';
import 'socket.dart';

class SocketMaestro extends Socket {
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel socket;
  late String name;
  late String passcode;

  SocketMaestro(String userName, String passCode) {
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
  }

  Future<void> connect() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080/concert/performer/maestro?name=$name=passcode=$passcode'));
  }
}
