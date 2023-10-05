class Group {
  late int id;
  late List<String> members;
  late String groupLeader;
  late DateTime? scheduledDate;

  Group({this.id = -1, this.members = const [], this.groupLeader = '', this.scheduledDate});

  factory Group.fromJson(Map json) {
    return Group(id: json['id'], members: json['members'], groupLeader: json['groupLeader']);
  }
}