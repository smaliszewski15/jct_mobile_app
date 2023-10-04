import 'dart:convert';
import 'package:flutter/material.dart';
import '../APIfunctions/concertAPI.dart';
import 'concert.dart';

class TagsUpdater {

  late List<Tag> tags;
  List<Tag> filteredTags = [];
  List<Tag> prevFilter = [];
  final changedNotifier = ValueNotifier<bool>(false);

  TagsUpdater() {
    _init();
  }

  _init() async {
    tags = await getTags();
  }

  void addFilteredTag(Tag entry) {
    if (filteredTags.length == 3) {
      filteredTags.removeAt(0);
    }
    filteredTags.add(entry);
  }

  void removeFilteredTag(Tag entry) {
    filteredTags.remove(entry);
  }

  void removeAllFilteredTags() {
    filteredTags = [];
    doUpdate();
  }

  void doUpdate() {
    prevFilter = filteredTags.toList();
    changedNotifier.value = true;
  }

  void finUpdate() {
    changedNotifier.value = false;
  }

  Future<List<Tag>> getTags() async {
    List<Tag> toRet = [];

    var res = await ConcertsAPI.getTags();

    if (res.statusCode != 200) {
      return [];
    }
    var data = json.decode(res.body);
    print(data);

    for(var entry in data['tags']) {
      toRet.add(Tag(entry['idTags'], entry['Tags']));
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
