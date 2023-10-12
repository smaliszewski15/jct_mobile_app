import 'package:shared_preferences/shared_preferences.dart';
import '../utils/globals.dart';

class User {
  late int id;
  late String name;
  late String username;
  late String email;
  late String password;
  late String? phoneNumber;
  bool isAdmin = false;
  bool isVerified = false;
  bool logged = false;
  late String authToken;

  User({this.id = -1, this.username = '', this.email = '', this.password = '', this.phoneNumber, this.name = '', this.authToken = '', this.isAdmin = false, this.isVerified = false});

  factory User.userFromJson(Map<String, dynamic> json) {
    String token = json.containsKey('token') ? json['token'] : '';
    var data = json['user'];
    int id = data['ID'];
    String name = data.containsKey('Name') ? data['Name'] : '';
    String username = data['UserName'];
    String email = data['Email'];
    String password = data.containsKey('Password') ? data['Password'] : '';
    String phonenumber = data.containsKey('Phone') ? data['Phone'] : '';
    bool isAdmin;
    if (data['IsAdmin'] == 1) {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    bool isVarified;
    if (data['IsVerified'] == 1) {
      isVarified = true;
    } else {
      isVarified = false;
    }
    User newUser = User(id: id, name: name, username: username, phoneNumber: phonenumber, email: email, password: password, authToken: token, isAdmin: isAdmin, isVerified: isVarified);
    newUser.logged = true;
    return newUser;
  }

  Future<bool> putUserInStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('name', name);
      prefs.setInt('id', id);
      prefs.setString('token', authToken);
      prefs.setString('email', email);
      prefs.setBool('isAdmin', isAdmin);
      prefs.setBool('isVerified', isVerified);
      prefs.setString('password', password);
      return true;
    } catch (e) {
      print("Unable to open preferences");
      return false;
    }
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

      return User.userFromJson(json);
    } catch (e) {
      print("Unable to open preferences");
      return User();
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (var key in keys) {
        prefs.remove(key);
      }

      return true;
    } catch (e) {
      print("Unable to open preferences");
      return true;
    }
  }

  String toString() {
    String user = 'Name: ${this.name}\nUsername: ${this.username}\nEmail: ${this.email}\nPhone Number: ${this.phoneNumber}';
    return user;
  }
}

User? user;
