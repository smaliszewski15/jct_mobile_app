import 'package:flutter/material.dart';
import 'package:john_cage_tribute/screens/error_screen.dart';
import 'package:john_cage_tribute/screens/user_profile.dart';
import '../screens/add_group.dart';
import '../screens/individual_group.dart';
import '../screens/skeleton.dart';
import '../screens/individual_concert.dart';
import '../screens/edit_profile.dart';
import '../screens/forgot_password.dart';
import '../screens/login.dart';
import '../screens/listen_screen.dart';
import '../screens/performer_screen.dart';
import '../screens/maestro_screen.dart';
import '../screens/register.dart';

class Routes {
  static const String skeletonScreen = '/skeleton';

  static const String concertPage = '/concerts/concert';

  static const String groupScreen = '/group/group';
  static const String addGroupScreen = '/group/add';
  static const String maestroScreen = '/group/recording/maestro';
  static const String performerScreen = '/group/recording/performer';
  static const String listenScreen = '/group/recording/listener';

  static const String profileScreen = '/profile';
  static const String editProfileScreen = '/profile/edit/information';
  static const String editPasswordScreen = '/profile/edit/password';

  static const String login = '/login';
  static const String forgot = '/login/forgotPassword';
  static const String register = '/register';

  static const String adminScreen = '/admin';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => Skeleton(),
    profileScreen: (context) => UserProfilePage(),
    editProfileScreen: (context) => EditUserProfilePage(),
    //editPasswordScreen: (context) => EditPasswordPage(),
    login: (context) => LogInPage(),
    forgot: (context) => ForgotPage(),
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
      case addGroupScreen:
        var arguments = settings.arguments;
        if (arguments is DateTime) {
          return MaterialPageRoute(builder: (context) => AddGroup(arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }
      case groupScreen:
        var arguments = settings.arguments;
        if (arguments is int) {
          return MaterialPageRoute(builder: (context) => IndividualGroup(arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }
      case maestroScreen:
        var arguments = settings.arguments;
        if (arguments is String) {
          return MaterialPageRoute(builder: (context) => MaestroScreen(passcode: arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }
      case performerScreen:
        var arguments = settings.arguments;
        if (arguments is String) {
          return MaterialPageRoute(builder: (context) => PerformerScreen(passcode: arguments));
        }
        else {
          return MaterialPageRoute(builder: (context) => ErrorScreen());
        }
      case listenScreen:
        var arguments = settings.arguments;
        if (arguments is String) {
          return MaterialPageRoute(builder: (context) => ListenScreen(passcode: arguments));
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
