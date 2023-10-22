import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_globals.dart';
import '../utils/user.dart';

class GroupsAPI {

  static const String apiRoute = '/api/schedules';

  static final authHeader = {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.authToken};

  static Future<http.Response> getSchedule(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '${apiRoute}/getSchedule', query),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> schedule(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/schedule'),
          body: json.encode(query),
          headers: authHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> prepare(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '${apiRoute}/prepareConcert'),
          body: json.encode(query),
          headers: authHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getNextConcert() async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '${apiRoute}/getNextConcert'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Map<String, dynamic> getGroups = {
    'groupsData': [
      {
        'title': 'Title 1',
        'maestro': 'Paul',
        'tags': 'soft`loud',
        'date': '2023-10-10',
        'time': '22:40',
        'members': [
          'Stephen',
          'Paul',
          'Kyle',
        ],
      },
      {
        'title': 'Title 2',
        'maestro': 'Stephen',
        'tags': 'jazz`rock',
        'date': '2023-10-13',
        'time': '21:20',
        'members': [
          'Stephen',
          'Paul',
          'Kyle',
        ],
      },
      {
        'title': 'Title 3',
        'maestro': 'Rayyan',
        'tags': 'soft`loud',
        'date': '2023-10-12',
        'time': '23:40',
        'members': [
          'Stephen',
          'Paul',
          'Kyle',
        ],
      },
      {
        'title': 'Title 4',
        'maestro': 'Himil',
        'tags': 'soft`loud',
        'date': '2023-10-13',
        'time': '22:00',
        'members': [
          'Stephen',
          'Paul',
          'Kyle',
        ],
      },
    ]
  };

  static Map<String, dynamic> getGroup = {
    'group': {
      'Title': 'Title 1',
      'GroupID': 2,
      'GroupLeaderName': 'Paul',
      'GroupLeaderID': 4,
      'Description': 'This is a description',
      'Tags': 'soft`loud',
      'Date': '2023-9-10',
      'Time': '22:40',
    },
  };
}