import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_globals.dart';
import '../models/user.dart';

List<int> passcodes = [];

class GroupsAPI {

  static const String apiRoute = '/api/schedules';

  static final authHeader = {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: user.authToken};

  static Future<http.Response> getSchedule(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/getSchedule', query),
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
      response = await http.post(Uri.http(API_PREFIX, '${apiRoute}/schedule'),
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
      response = await http.post(Uri.http(API_PREFIX, '${apiRoute}/prepareConcert'),
          body: json.encode(query),
          headers: authHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> validatePerformer(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.post(Uri.http(API_PREFIX, '${apiRoute}/validatePerformer'),
          body: json.encode(query),
          headers: authHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> validateListener(Map<String, dynamic> query) async {
    http.Response response;

    try {
      response = await http.post(Uri.http(API_PREFIX, '${apiRoute}/validateListener'),
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
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/getNextConcert'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getMixMethods() async {
    http.Response response;

    try {
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/getMixMethods'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
