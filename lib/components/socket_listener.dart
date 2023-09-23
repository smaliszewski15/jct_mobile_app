import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../APIFunctions/api_globals.dart';

class SocketTest {
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel socket;

  SocketTest() {
    _init();
  }

  _init() {
    connect();
  }

  void disconnect() {
    socket.sink.add('disconnect');
    socket.sink.close();
    buttonNotifier.value = false;
  }

  void connect() {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080'));
    socket.stream.listen(
      (data) {
        print(data);
        buttonNotifier.value = true;
      },
      onError: (error) => print(error),
    );
  }
}