import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../APIfunctions/userAPI.dart';
import '../utils/globals.dart';

class User {
  late int id;
  late String username;
  late String email;
  late String password;
  bool isAdmin = false;
  bool isVerified = false;
  bool logged = false;
  late String authToken;

  User({this.id = -1, this.username = '', this.email = '', this.password = '', this.authToken = '', this.isAdmin = false, this.isVerified = false});

  factory User.userFromJson(Map<String, dynamic> json) {
    String token = json.containsKey('token') ? json['token'] : '';
    var data = json['user'];
    int id = data['ID'];
    String username = data['UserName'];
    String email = data['Email'];
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
    User newUser = User(id: id, username: username, email: email, authToken: token, isAdmin: isAdmin, isVerified: isVarified);
    newUser.logged = true;
    return newUser;
  }

  void setPassword(String pword) {
    this.password = pword;
  }

  Future<bool> putUserInStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setInt('ID', id);
      prefs.setString('UserName', username);
      prefs.setString('Email', email);
      prefs.setString('Password', password);

      return true;
    } catch (e) {
      print("Unable to open preferences");
      return false;
    }
  }

  static Future<User> _loginUser(Map<String,dynamic> userData) async {
    User toRet = User();
    try {
      Map<String, dynamic> entries = {
        'identifier': userData['UserName'],
        'password': userData['Password'],
      };

      final res = await UserAPI.login(entries);
      if (res.statusCode != 200) {
        print(res.statusCode);
        print(res.body);
        return toRet;
      }
      var data = json.decode(res.body);

      toRet = User.userFromJson(data);
      toRet.setPassword(userData['Password']);
      toRet.putUserInStorage();
    } catch (e) {
      print(e.toString());
      return toRet;
    }
    return toRet;
  }

  Future<User> getUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String un = prefs.getString("UserName") ?? '';

      if (un.isEmpty) {
        print('user not in storage');
        return User();
      }

      try {
        Map<String,dynamic> userData = {};
        for (var key in maps) {
          if (key == 'ID') {
            userData[key] = prefs.getInt(key);
          } else {
            userData[key] = prefs.getString(key);
          }
        }

        User toRet = await User._loginUser(userData);
        if (toRet.logged == false) {
          await prefs.clear();
        }

        return toRet;
      } catch (e) {
        print(e.toString());
        return User();
      }
    } catch (e) {
      print("Unable to open preferences");
      return User();
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      user = User();

      return true;
    } catch (e) {
      print("Unable to open preferences");
      return true;
    }
  }

  String toString() {
    String user = 'Username: ${this.username}\nEmail: ${this.email}\nPassword: ${this.password}';
    return user;
  }
}

User user = User();
