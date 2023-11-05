import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/concert_tags_manager.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';

class TagFilterDrawer extends StatefulWidget {
  late TagsUpdater tags;

  TagFilterDrawer(this.tags);

  @override
  _TagFilterDrawerState createState() => _TagFilterDrawerState();
}

class _TagFilterDrawerState extends State<TagFilterDrawer> {
  bool wasChanged = false;

  @override
  void initState() {
    super.initState();
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
              Wrap(
                children: widget.tags.tags.map((entry) => Container(
                    decoration: BoxDecoration(
                      color: !widget.tags.filteredTags.contains(entry) ? white : mainSchemeColor,
                      border: Border.all(color: black, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(roundedCorners)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextButton(
                      onPressed: () {
                        if (widget.tags.filteredTags.contains(entry)) {
                          widget.tags.filteredTags.remove(entry);
                        } else {
                          widget.tags.filteredTags.add(entry);
                        }
                        if (!wasChanged) {
                          wasChanged = true;
                        }
                        setState(() {});
                      },
                      child: Text(
                        entry.tagName,//.capitalize(),
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
                          widget.tags.removeAllFilteredTags();
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
}
