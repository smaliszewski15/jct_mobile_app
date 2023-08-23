import 'package:flutter/material.dart';

class NavStateManager {

  late String title;
  final buttonNotifier = ValueNotifier<NavState>(NavState.home);

  NavStateManager() {
    _init();
  }

  void _init() async {
    title = 'A Tribute to John Cage';
  }

  void home() {
    title = 'A Tribute to John Cage';
    buttonNotifier.value = NavState.home;
  }

  void concert() {
    title = 'Concerts';
    buttonNotifier.value = NavState.concert;
  }

  void groups() {
    title = 'Groups';
    buttonNotifier.value = NavState.group;
  }

  void profile() {
    title = 'My Profile';
    buttonNotifier.value = NavState.profile;
  }

  void testing() {
    title = 'Current Test Features';
    buttonNotifier.value = NavState.test;
  }
}

enum NavState{
  home, concert, group, profile, admin, test
}
