class Group {
  late int groupID;
  late String maestro;
  late int maestroID;
  late String title;
  late String tags;
  late String description;

  late List<String>? members;
  late DateTime? date;
  late List<int>? passcodes;


  Group({this.groupID = -1, this.members = const [], this.maestro = '', this.maestroID = -1, this.tags = '', this.title = '', this.description = '', this.date, this.passcodes});

  factory Group.fromJson(Map json) {
    List<String> members = json['members'];
    String leader = json['maestro'];
    String title = json['title'];
    DateTime date = ConvertToDate(json['date'], json['time']);
    String tags = json['tags'];
    return Group(members: members, maestro: leader, title: title, date: date, tags: tags);
  }

  factory Group.fromScheduleJson(Map json) {
    String leader = json['GroupLeaderName'];
    String title = json['Title'];
    int id = json['GroupID'];
    int maestroID = json['GroupLeaderID'];
    String description = json['Description'];
    DateTime date = ConvertToDate(json['Date'], json['Time']);
    String tags = json['Tags'];
    return Group(groupID: id, maestro: leader, maestroID: maestroID, title: title, date: date, tags: tags, description: description);
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
    return toRet;
  }

  static DateTime ConvertToDate(String date, String time) {
    List<String> dateParts = date.split('-');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[2]);
    int day = int.parse(dateParts[1]);
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime toRet = DateTime(year, month, day, hour, minute);
    return toRet;
  }

  String toString() {
    String group = '\nTitle: ${this.title}\nPerformers: ${this.members}\nTags: ${this.tags}\nDate: ${this.date}';
    return group;
  }
}