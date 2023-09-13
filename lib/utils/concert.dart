import '../utils/globals.dart';

class Concert {
  late String title;
  late int id;

  Concert({this.title = '', this.id = -1});

  Concert songFromJson(Map<String, dynamic> json) {
    String title = json.containsKey('Title') ? json['Title'] : '';
    int ID = json.containsKey('ID') ? json['ID'] : '';
    Concert newConcert = Concert(title: title, id: ID);
    return newConcert;
  }

  String toString() {
    String concert = 'Title: ${this.title}\nID: ${this.id}';
    return concert;
  }
}
