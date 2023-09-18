import 'package:flutter/material.dart';
import '../APIfunctions/concertAPI.dart';

class TagsUpdater {

  late List<String> tags;
  late List<String> filteredTags;
  final changedNotifier = ValueNotifier<bool>(false);

  TagsUpdater() {
    _init();
  }

  _init() {
    tags = getTags();
  }

  void addFilteredTag(String entry) {
    filteredTags.add(entry);
  }

  void removeFilteredTag(String entry) {
    filteredTags.remove(entry);
  }

  void removeAllFilteredTags() {
    filteredTags = [];
    doUpdate();
  }

  void doUpdate() {
    changedNotifier.value = true;
  }

  void finUpdate() {
    changedNotifier.value = false;
  }

  List<String> getTags() {
    List<String> toRet = [];
    for(var entry in ConcertsAPI.getTags['tags']) {
      toRet.add(entry);
    }

    return toRet;
  }
}
