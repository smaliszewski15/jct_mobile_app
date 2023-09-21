import 'dart:convert';
import 'package:flutter/material.dart';
import '../APIfunctions/concertAPI.dart';

class TagsUpdater {

  late List<String> tags;
  late List<String> filteredTags;
  final changedNotifier = ValueNotifier<bool>(false);

  TagsUpdater() {
    _init();
  }

  _init() async {
    tags = await getTags();
    filteredTags = [];
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

  Future<List<String>> getTags() async {
    List<String> toRet = [];

    var res = await ConcertsAPI.getTags();

    if (res.statusCode != 200) {
      return [];
    }
    var data = json.decode(res.body);

    for(var entry in data['tags']) {
      toRet.add(entry);
    }

    return toRet;
  }

  /*List<String> getTags() {
    List<String> toRet = [];
    for(var entry in ConcertsAPI.getTags['tags']) {
      toRet.add(entry);
    }

    return toRet;
  }*/
}
