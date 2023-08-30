import 'package:flutter/material.dart';

class HomeStateManager {

  final buttonNotifier = ValueNotifier<HomeState>(HomeState.home);

  HomeStateManager() {
    _init();
  }

  void _init() async {
  }

  void home() {
    buttonNotifier.value = HomeState.home;
  }

  void about_us() {
    buttonNotifier.value = HomeState.about_us;
  }

  void john_cage() {
    buttonNotifier.value = HomeState.john_cage;
  }

  void upcoming_concerts() {
    buttonNotifier.value = HomeState.upcoming_concerts;
  }

}

enum HomeState {
  home,
  about_us,
  john_cage,
  upcoming_concerts,
}
