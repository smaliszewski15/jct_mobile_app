import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'concerts_screen.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';
import '../components/concert_filter.dart';
import '../components/group_filter.dart';
import '../components/profile_drawer.dart';
import '../managers/concert_search_manager.dart';
import '../managers/schedule_manager.dart';
import '../managers/nav_bar_manager.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../models/user.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late final NavStateManager _navManager;
  late final ConcertSearchManager _concertFilterManager;
  late final ScheduleManager _scheduleManager;
  Future<bool>? done;
  bool asked = false;

  @override
  void initState() {
    super.initState();
    _navManager = NavStateManager();
    _concertFilterManager = ConcertSearchManager();
    _scheduleManager = ScheduleManager();
    done = getUser();
    askPerms();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void askPerms() async {
    final status = await Permission.notification.status;

    if (!status.isGranted && !asked) {
      Permission.notification.request();
      asked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    if (!updatedTextStyles && textScale != 1) {
      updateTextStyles(textScale);
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        title: Text(
          _navManager.title,
          style: titleTextStyle,
        ),
        actions: _navManager.buttonNotifier.value == NavState.concert
            ? <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: invalidColor,
                ),
                iconSize: 30,
                onPressed: () =>
                    Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ]
            : _navManager.buttonNotifier.value == NavState.schedule
            ? <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.calendar_month,
                  color: invalidColor,
                ),
                iconSize: 35,
                onPressed: () =>
                    Scaffold.of(context).openEndDrawer(),
              );
            },
          )
        ]
            : null,
        leading: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/default-profile-image.jpg'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: mainSchemeColor,
        automaticallyImplyLeading: false,
      ),
      drawer: FutureBuilder(
        future: done,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              return HomeDrawer();
          }
        },
      ),
      endDrawer: _navManager.buttonNotifier.value == NavState.concert
          ? ConcertFilterDrawer(_concertFilterManager)
          :
      _navManager.buttonNotifier.value == NavState.schedule
          ? FilterDrawer(_scheduleManager) : null,
      onEndDrawerChanged: (isOpened) {
        if (!isOpened) {
          if (_navManager.buttonNotifier.value == NavState.concert) {
            // if (!Tag.ListEquals(
            //     _tagManager.prevFilter, _tagManager.filteredTags)) {
            //   _tagManager.doUpdate();
            // }
            if (_concertFilterManager.isChanged()) {
              _concertFilterManager.doUpdate();
            }
          }
          if (_navManager.buttonNotifier.value == NavState.schedule) {
            if (_scheduleManager.isChanged()) {
              _scheduleManager.doUpdate();
            }
          }
        }
      },
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onPanEnd: (details) {
              bool vertDrag = details.velocity.pixelsPerSecond.dy.abs() > details.velocity.pixelsPerSecond.dx.abs();
              if (details.velocity.pixelsPerSecond.dx > 0 && !vertDrag) {
                switch (_navManager.buttonNotifier.value) {
                  case NavState.home:
                    Scaffold.of(context).openDrawer();
                    break;
                  case NavState.concert:
                    _navManager.home();
                    setState(() => {});
                    break;
                  case NavState.schedule:
                    _navManager.concert();
                    setState(() => {});
                    break;
                  case NavState.admin:
                    _navManager.schedule();
                    setState(() => {});
                    break;
                  default: break;
                }
              }else if (details.velocity.pixelsPerSecond.dx < 0 && !vertDrag) {
                switch (_navManager.buttonNotifier.value) {
                  case NavState.home:
                    _navManager.concert();
                    setState(() => {});
                    break;
                  case NavState.concert:
                    _navManager.schedule();
                    setState(() => {});
                    break;
                  case NavState.schedule:
                    if (user.isAdmin) {
                      _navManager.admin();
                      setState(() => {});
                    }
                    break;
                  default: break;
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: backgroundColor,
              child: ValueListenableBuilder<NavState>(
                valueListenable: _navManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case NavState.home:
                      return HomeScreen();
                    case NavState.concert:
                      return ConcertsScreen(_concertFilterManager);
                    case NavState.schedule:
                      return ScheduleScreen(_scheduleManager);
                    case NavState.admin:
                      return Container();
                  }
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: mainSchemeColor,
        child: SizedBox(
          height: navBarHeight,
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      if (_navManager.buttonNotifier.value !=
                          NavState.home) {
                        _navManager.home();
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          size: bottomIconSize,
                          color: _navManager.buttonNotifier.value ==
                              NavState.home
                              ? accentColor
                              : white,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize:
                            navBarTextSize, //navBarTextSize,
                            color: _navManager.buttonNotifier.value ==
                                NavState.home
                                ? accentColor
                                : white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      if (_navManager.buttonNotifier.value !=
                          NavState.concert) {
                        _navManager.concert();
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.mic_external_on,
                          size: bottomIconSize,
                          color: _navManager.buttonNotifier.value ==
                              NavState.concert
                              ? accentColor
                              : white,
                        ),
                        Text(
                          'Concerts',
                          style: TextStyle(
                            fontSize:
                            navBarTextSize, //navBarTextSize,
                            color: _navManager.buttonNotifier.value ==
                                NavState.concert
                                ? accentColor
                                : white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      if (_navManager.buttonNotifier.value !=
                          NavState.schedule) {
                        _navManager.schedule();
                        setState(() {});
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.groups,
                          size: bottomIconSize,
                          color: _navManager.buttonNotifier.value ==
                              NavState.schedule
                              ? accentColor
                              : white,
                        ),
                        Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize:
                            navBarTextSize, //user.isAdmin ? navBarTextSize,
                            color: _navManager.buttonNotifier.value ==
                                NavState.schedule
                                ? accentColor
                                : white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                if (user.isAdmin)
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.construction,
                            size: bottomIconSize,
                            color: _navManager.buttonNotifier.value ==
                                NavState.admin
                                ? accentColor
                                : white,
                          ),
                          Text(
                            'Admin',
                            style: TextStyle(
                              fontSize:
                              navBarTextSize,
                              color: _navManager.buttonNotifier.value ==
                                  NavState.admin
                                  ? accentColor
                                  : white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getUser() async {
    user = await User().getUserFromStorage();
    if (!user.logged && context.mounted) {
      //_showUnableLoginSnack(context);
    }
    return true;
  }

  void _showUnableLoginSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            return true;
          },
          child: Text('Could not retrieve user from storage'),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
