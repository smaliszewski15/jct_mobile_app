import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../APIFunctions/api_globals.dart';

class SocketConnect {
  final buttonNotifier = ValueNotifier<bool>(false);
  late WebSocketChannel socket;
  late SocketType type;
  bool _isConnected = false;

  SocketConnect(SocketType newType) {
    type = newType;
    _init();
  }

  _init() {
    if (type == SocketType.maestro) {
      connectForMaestro();
    } else if (type == SocketType.performer) {
      connectForRecording();
    } else if (type == SocketType.listener) {
      connectForListening();
    }
  }

  void disconnect() {
    socket.sink.add('disconnect');
    socket.sink.close();
    buttonNotifier.value = false;
  }

  Future<void> connectForMaestro() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080/concert/performer/maestro'));
    _isConnected = true;
  }

  Future<void> connectForRecording() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080/concert/performer'));
    _isConnected = true;
  }

  Future<void> connectForListening() async {
    socket = WebSocketChannel.connect(Uri.parse('ws://$API_PREFIX:8080/concert/audience'));
    _isConnected = true;
  }
}

enum SocketType {
  listener,
  performer,
  maestro
}
