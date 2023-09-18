import 'package:flutter/material.dart';

class TagsUpdater {

  late List<String> tags;
  final changedNotifier = ValueNotifier<bool>(false);

  TagsUpdater() {
    _init();
  }

  _init() {
    tags = [];
  }

  void doUpdate() {
    changedNotifier.value = true;
  }

  void finUpdate() {
    changedNotifier.value = false;
  }
}
