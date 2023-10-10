class Group {
  late int id;
  late List<String> members;
  late String groupLeader;
  late DateTime? date;
  late String tags;
  late String title;
  late String description;


  Group({this.id = -1, this.members = const [], this.groupLeader = '', this.tags = '', this.title = '', this.description = '', this.date});

  factory Group.fromJson(Map json) {
    List<String> members = json['members'];
    String leader = json['maestro'];
    String title = json['title'];
    DateTime date = ConvertToDate(json['date'], json['time']);
    String tags = json['tags'];
    return Group(members: members, groupLeader: leader, title: title, date: date, tags: tags);
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