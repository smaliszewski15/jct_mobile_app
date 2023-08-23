import 'package:shared_preferences/shared_preferences.dart';
import '../utils/globals.dart';

class User {
  late String firstName;
  late String lastName;
  late String username;
  late String email;
  late String password;
  late String phoneNumber;
  bool isAdmin = false;
  bool logged = false;

  User({this.username = '', this.email = '', this.password = '', this.phoneNumber = '', this.firstName = '', this.lastName = ''});

  User userFromJson(Map<String, dynamic> json) {
    String first = json.containsKey('firstName') ? json['firstName'] : '';
    String last = json.containsKey('lastName') ? json['lastName'] : '';
    String username = json['username'];
    String email = json['email'];
    String password = json.containsKey('password') ? json['password'] : '';
    String phonenumber = json.containsKey('phone_number') ? json['phone_number'] : '';
    User newUser = User(firstName: first, lastName: last, username: username, phoneNumber: phonenumber, email: email, password: password);
    newUser.logged = true;
    return newUser;
  }

  Future<User> getUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String un = prefs.getString("username") ?? '';

      if (un.isEmpty) {
        return User();
      }

      Map<String, dynamic> json = {};
      for (var key in maps) {
        json[key] = prefs.getString(key);
      }

      return User().userFromJson(json);
    } catch (e) {
      print("Unable to open preferences");
      return User();
    }
  }

  Future<User> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      for (var key in maps) {
        prefs.remove(key);
      }

      return User();
    } catch (e) {
      print("Unable to open preferences");
      return User();
    }
  }

  String toString() {
    String user = 'First Name: ${this.firstName}\nLast Name: ${this.lastName}\nUsername: ${this.username}\nEmail: ${this.email}\nPhone Number: ${this.phoneNumber}';
    return user;
  }
}

User? user;
