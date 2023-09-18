import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:john_cage_tribute/components/concert_tags_manager.dart';
import '../APIfunctions/concertAPI.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class TagFilterDrawer extends StatefulWidget {
  late TagsUpdater tags;

  TagFilterDrawer(this.tags);

  @override
  _TagFilterDrawerState createState() => _TagFilterDrawerState();
}

class _TagFilterDrawerState extends State<TagFilterDrawer> {
  late List<String> tags;
  List<String> filteredTags = [];
  bool wasChanged = false;

  @override
  void initState() {
    super.initState();
    tags = getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          ListView(
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Filter by concert tags:',
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              /*ListView.builder(
                  shrinkWrap: true,
                  itemCount: tags.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: OutlinedButton(
                        onPressed: null,
                        child: Text(
                          tags[index].capitalize(),
                          style: defaultTextStyle,
                        ),
                      ),
                    );
                  }
              ),*/
              Wrap(
                children: tags.map((entry) => Container(
                    decoration: BoxDecoration(
                      color: !filteredTags.contains(entry) ? white : mainSchemeColor,
                      border: Border.all(color: black, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextButton(
                      onPressed: () {
                        if (filteredTags.contains(entry)) {
                          filteredTags.remove(entry);
                        } else {
                          filteredTags.add(entry);
                        }
                        if (!wasChanged) {
                          wasChanged = true;
                        }
                        setState(() {});
                      },
                      child: Text(
                        entry.capitalize(),
                        style: const TextStyle(
                          fontSize: infoFontSize,
                          color: black,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        if(wasChanged) {
                          widget.tags.doUpdate();
                        }
                        widget.tags.finUpdate();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20,
                        ),
                      )
                    ),
                    TextButton(
                        onPressed: () {
                          filteredTags = [];
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(
                            color: red,
                            fontSize: 20,
                          ),
                        )
                    ),
                  ]
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  List<String> getTags() {
    List<String> toRet = [];
    for(var entry in ConcertsAPI.getTags['tags']) {
      toRet.add(entry);
    }

    return toRet;
  }
}

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
