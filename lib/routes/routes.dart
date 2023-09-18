import 'package:flutter/material.dart';
import 'package:john_cage_tribute/screens/error_screen.dart';
import 'package:john_cage_tribute/screens/user_profile.dart';
import '../screens/skeleton.dart';
import '../screens/individual_concert.dart';
import '../screens/edit_profile.dart';
import '../screens/login.dart';
import '../screens/register.dart';

class Routes {
  static const String skeletonScreen = '/skeleton';

  static const String concertPage = '/concerts/concert';

  static const String profileScreen = '/profile';
  static const String editProfileScreen = '/profile/edit/information';
  static const String editPasswordScreen = '/profile/edit/password';

  static const String login = '/login';
  static const String register = '/register';

  static const String adminScreen = '/admin';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => Skeleton(),
    profileScreen: (context) => UserProfilePage(),
    editProfileScreen: (context) => EditUserProfilePage(),
    editPasswordScreen: (context) => EditPasswordPage(),
    login: (context) => LogInPage(),
    register: (context) => RegisterPage(),
    //addGroupScreen: (context) => AddGroup(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case concertPage:
        var arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(builder: (context) => ConcertPage(arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }
      /*case groupPage:
        var arguments = settings.arguments;
        if (arguments is String) {
          return MaterialPageRoute(builder: (context) => Group(arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }*/
      default:
        return MaterialPageRoute(builder: (context) => ErrorScreen());
    }
  }

}
