import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_globals.dart';
import '../utils/user.dart';

class UserAPI {
  static const String apiRoute = '/api/users';

  static Future<http.Response> register(Map<String, dynamic> queries) async {
    http.Response response;

    try {
      response = await http.post(
          Uri.https(API_PREFIX, '${apiRoute}/register'),
          body: json.encode(queries),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> login(Map<String, dynamic> query) async {
    http.Response response;

    var encoded = json.encode(query);
    print(encoded);

    try {
      response = await http.post(
          Uri.https(API_PREFIX, '${apiRoute}/login'),
          body: json.encode(query),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> validateUser() async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '${apiRoute}/validate'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getUser(int id) async {
    http.Response response;

    try {
      response =
          await http.get(Uri.https(API_PREFIX, '${apiRoute}/$id'), headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: user.authToken
      });
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
