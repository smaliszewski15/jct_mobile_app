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

  void testing() {
    title = 'Current Test Features';
    buttonNotifier.value = NavState.test;
  }

  void testing2() {
    title = 'Current Test2 Features';
    buttonNotifier.value = NavState.test2;
  }

  void admin() {
    title = 'Admin Page';
    buttonNotifier.value = NavState.admin;
  }
}

enum NavState{
  home, concert, schedule, admin, test, test2
}
