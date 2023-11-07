import 'package:intl/intl.dart';
import '../APIfunctions/api_globals.dart';

class Group {
  late int groupID;
  late String maestro;
  late int maestroID;
  late String title;
  late String tags;
  late String description;

  late String? groupName;
  late List<String>? members;
  late DateTime? date;
  late List<int>? passcodes;


  Group({this.groupID = -1, this.members, this.maestro = '', this.maestroID = -1, this.tags = '', this.title = '', this.description = '', this.date, this.passcodes, this.groupName});

  factory Group.fromNextJson(Map json) {
    print(json);
    String leader = json['GroupLeaderName'] ?? '';
    String title = json['Title'] ?? '';
    int groupID = json['GroupID'] ?? -1;
    int maestroID = json['GroupLeaderID'] ?? -1;
    String description = json['Description'] ?? '';
    DateTime date = ConvertToDate(json['Date'], json['Time']);
    String tags = json['Tags'] ?? '';
    return Group(groupID: groupID, maestro: leader, maestroID: maestroID, title: title, date: date, tags: tags, description: description);
  }

  factory Group.fromScheduleJson(Map json) {
    String leader = json['GroupLeaderName'] ?? '';
    String title = json['Title'] ?? '';
    int id = json['GroupID'] ?? -1;
    int maestroID = json['GroupLeaderID'] ?? -1;
    String description = json['Description'] ?? '';
    DateTime date = ConvertToDate(json['Date'], json['Time']);
    String tags = json['Tags'] ?? '';
    return Group(groupID: id, maestro: leader, maestroID: maestroID, title: title, date: date, tags: tags, description: description);
  }

  factory Group.fromDateConcert(String date) {
    DateTime newDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(date, true);
    return Group(date: newDate.toLocal());
  }

  void addPasscodes(Map json) {
    this.passcodes = _getListPasscodes(json);
  }

  static List<int> _getListPasscodes(Map json) {
    List<int> toRet = [];
    toRet.add(json['MaestroPasscode']);
    toRet.add(json['User1Passcode']);
    toRet.add(json['User2Passcode']);
    toRet.add(json['User3Passcode']);
    toRet.add(json['User4Passcode']);
    toRet.add(json['ListenerPasscode']);
    return toRet;
  }



  String toString() {
    String group = '\nTitle: ${this.title}\nPerformers: ${this.members}\nTags: ${this.tags}\nDate: ${this.date}';
    return group;
  }
}