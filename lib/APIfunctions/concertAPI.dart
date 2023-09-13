import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_globals.dart';

class Concerts {
  static const String apiRoute = '';

  static Future<http.Response> searchSongs(Map<String,dynamic> query) async {//Map<String, dynamic> queries) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '/api/searchSongs', query),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }
}
