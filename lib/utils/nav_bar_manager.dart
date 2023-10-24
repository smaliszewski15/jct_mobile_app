import 'package:flutter/material.dart';

class NavStateManager {

  late String title;
  final buttonNotifier = ValueNotifier<NavState>(NavState.home);

  NavStateManager() {
    _init();
  }

  void _init() async {
    title = 'Home';
  }

  void home() {
    title = 'Home';
    buttonNotifier.value = NavState.home;
  }

  void concert() {
    title = 'Concerts';
    buttonNotifier.value = NavState.concert;
  }

  void schedule() {
    title = 'Schedule';
    buttonNotifier.value = NavState.schedule;
  }

  void admin() {
    title = 'Admin Page';
    buttonNotifier.value = NavState.admin;
  }
}

enum NavState{
  home, concert, schedule, admin
}
