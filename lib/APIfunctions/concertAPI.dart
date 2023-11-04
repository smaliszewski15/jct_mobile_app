import 'package:http/http.dart' as http;
import 'api_globals.dart';

class ConcertsAPI {
  static const String apiRoute = '/api/concerts';

  static Future<http.Response> searchSongs(Map<String, dynamic> queries) async {
    http.Response response;

    try {
      //URI encodes : into %3A. If the date filter doesn't work, its probably this
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/searchSongs', queries),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getSongData(Map<String, dynamic> query) async {
    http.Response response;
    print(query);

    try {
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/getSongData', query),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  static Future<http.Response> getTags() async {
    http.Response response;

    try {
      response = await http.get(Uri.http(API_PREFIX, '${apiRoute}/getTags'),
          headers: baseHeader);
    } catch (e) {
      print(e.toString());
      throw Exception('Could not connect to server');
    }

    return response;
  }

  /*static Map<String, dynamic> searchSongs = {
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
  };*/
}
