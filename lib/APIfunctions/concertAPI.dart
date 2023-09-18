import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_globals.dart';

class ConcertsAPI {
  final String apiRoute = '';

  /*static Future<http.Response> searchSongs() async {//Map<String, dynamic> queries) async {
    http.Response response;

    try {
      response = await http.post(Uri.https(API_PREFIX, '/api/searchSongs'),//, queries),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }*/

  static Future<http.Response> searchSongss() async {//Map<String, dynamic> queries) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '/api/concerts/searchSongs'),//, queries),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getSongData(int id) async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '/api/concerts/getSongData?id=$id'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getTagss() async {
    http.Response response;

    try {
      response = await http.get(Uri.https(API_PREFIX, '/api/concerts/getTags'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Map<String, dynamic> searchSongs = {
    'searchResults': [
      {
        'id': 1,
        'maestro': 'Paul',
        'title': 'Concert One',
        'tags': [
          'Slow',
          'Quiet',
          'Loud',
        ],
      },
      {
        'id': 2,
        'maestro': 'Paul',
        'title': 'Concert Two',
        'tags': [
          'Slow',
          'Quiet',
          'Loud',
        ],
      },
    ],
  };

  static Map<String,dynamic> getSong = {
    'songData': {
      'id': 1,
      'maestro': "Paul",
      'performers': [
        'Kyle',
        'Paul',
        'Stephen',
        'Rayyan',
        'Himil',
      ],
      'title': 'Concert Two',
      'tags': [
        'Slow',
        'Quiet',
        'Loud',
      ],
      'description': 'High intensity pipe action yahoo.',
      'date': '2023-September-11-6-00-PM',
    },
  };

  static Map<String, dynamic> getTags = {
    'tags': [
      'fast',
      'slow',
      'quiet',
      'loud',
    ]
  };
}
