import 'api_globals.dart';

class GroupsAPI {

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
      'title': 'Title 1',
      'maestro': 'Paul',
      'tags': 'soft`loud',
      'date': '2023-9-10',
      'time': '22:40',
      'members': [
        'Stephen',
        'Paul',
        'Kyle',
      ],
      'description': 'This is a description of the group and what will be the concert ig',
    },
  };
}