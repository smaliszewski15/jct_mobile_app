import '../APIfunctions/api_globals.dart';

class Concert {
  late String title;
  late int id;
  late String maestro;
  late List<String> performers;
  late String tags;
  late String description;
  late DateTime? date;


  Concert({this.title = '', this.id = -1, this.maestro = '', this.performers = const [], this.tags = '', this.description = '', this.date});

  factory Concert.searchedSong(Map json) {
    String title = json['Title'] ?? '';
    int id = json['GroupID'] ?? -1;
    String maestro = json['GroupLeaderName'] ?? '';
    String tags = json['Tags'] ?? '';
    String description = json['Description'] ?? '';
    DateTime date = ConvertToDate(json['Date'], json['Time']);
    Concert newConcert = Concert(title: title, id: id, maestro: maestro, tags: tags, description: description, date: date);
    return newConcert;
  }

  static Concert songFromJson(Map<String, dynamic> json) {
    String title = json['Title'] ?? '';
    int id = json['GroupID'] ?? -1;
    String maestro = json['GroupLeaderName'] ?? '';
    //List<String> perfs = _getPerformers(json);
    String tags = json['Tags'] ?? '';
    String description = json.containsKey('Description') ? json['Description'] : '';
    List<String> dateParts = json['Date'].split('-');
    List<String> timeParts = json['Time'].split(':');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime date = DateTime(year, month, day, hour, minute);
    Concert newConcert = Concert(title: title, id: id, maestro: maestro, tags: tags, description: description, date: date);
    return newConcert;
  }

  static List<String> _getPerformers(Map json) {
    List<String> toRet = [];
    for (int i = 1; i <= 4; i++) {
      if (json.containsKey('User${i}Name')) {
        toRet.add(json['User${i}Name'] ?? '');
        i++;
      }
    }
    return toRet;
  }

  String toString() {
    String concert = 'Title: ${this.title}\nID: ${this.id}\nPerformers: ${this.performers}\nTags: ${this.tags}\nDescription: ${this.description}\nDate: ${this.date}';
    return concert;
  }
}

class Tag {
  late int tagID;
  late String tagName;

  Tag(this.tagID, this.tagName);

  static equals(Tag? a, Tag? b) {
    if (a == null || b == null) {
      return false;
    }

    if (a.tagID != b.tagID) {
      return false;
    }

    if (a.tagName != b.tagName) {
      return false;
    }

    return true;
  }

  static ListEquals(List<Tag>? a, List<Tag>? b) {
    if (a == null || b == null) {
      return false;
    }
    if (a.isEmpty) {
      return false;
    }
    if (b.isEmpty) {
      return false;
    }
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length || i < b.length; i++) {
      if (a[i].tagID != b[i].tagID) {
        return false;
      }
      if (a[i].tagName != b[i].tagName) {
        return false;
      }
    }

    return true;
  }
}
