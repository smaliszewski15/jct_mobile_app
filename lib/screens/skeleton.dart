import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'concerts_screen.dart';
import 'home_screen.dart';
import 'test_screen.dart';
import 'schedule_screen.dart';
import 'socket_recording_toggle.dart';
import '../components/concert_filter.dart';
import '../components/group_filter.dart';
import '../components/profile_drawer.dart';
import '../utils/concert_tags_manager.dart';
import '../utils/colors.dart';
import '../utils/concert.dart';
import '../utils/globals.dart';
import '../utils/schedule_manager.dart';
import '../utils/nav_bar_manager.dart';
import '../utils/user.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late final NavStateManager _navManager;
  late final TagsUpdater _tagManager;
  late final ScheduleManager _scheduleManager;
  Future<bool>? done;

  @override
  void initState() {
    super.initState();
    _navManager = NavStateManager();
    _tagManager = TagsUpdater();
    _scheduleManager = ScheduleManager();
    done = getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: done,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              print('Error');
            }
            return Scaffold(
              appBar: AppBar(
                leadingWidth: 80,
                title: Text(
                  _navManager.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: textColor,
                  ),
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
                    return OutlinedButton(
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
                backgroundColor: black,
                automaticallyImplyLeading: false,
              ),
              drawer: HomeDrawer(),
              endDrawer:
              // endDrawer: _navManager.buttonNotifier.value == NavState.concert
              //     ? TagFilterDrawer(_tagManager)
              //     :
              _navManager.buttonNotifier.value == NavState.schedule
                  ? FilterDrawer(_scheduleManager) : null,
              onEndDrawerChanged: (isOpened) {
                if (!isOpened) {
                  // if (_navManager.buttonNotifier.value == NavState.concert) {
                  //   if (!Tag.ListEquals(
                  //       _tagManager.prevFilter, _tagManager.filteredTags)) {
                  //     _tagManager.doUpdate();
                  //   }
                  // }
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
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
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
                        }
                      } else if (details.primaryVelocity! < 0) {
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
                            if (user!.isAdmin) {
                              _navManager.admin();
                              setState(() => {});
                            }
                            break;
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
                              return ConcertsScreen(_tagManager);
                            case NavState.test:
                              return TestScreen();
                            case NavState.test2:
                              return SocketScreen();
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
                color: black,
                child: SizedBox(
                  height: navBarHeight,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
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
                                      ? mainSchemeColor
                                      : white,
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize:
                                        smallerNavBarTextSize, //navBarTextSize,
                                    color: _navManager.buttonNotifier.value ==
                                            NavState.home
                                        ? mainSchemeColor
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
                          child: OutlinedButton(
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
                                      ? mainSchemeColor
                                      : white,
                                ),
                                Text(
                                  'Concerts',
                                  style: TextStyle(
                                    fontSize:
                                        smallerNavBarTextSize, //navBarTextSize,
                                    color: _navManager.buttonNotifier.value ==
                                            NavState.concert
                                        ? mainSchemeColor
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
                          child: OutlinedButton(
                            onPressed: () {
                              if (_navManager.buttonNotifier.value !=
                                  NavState.test) {
                                _navManager.testing();
                                setState(() {});
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.remove_done,
                                  size: bottomIconSize,
                                  color: _navManager.buttonNotifier.value ==
                                          NavState.test
                                      ? mainSchemeColor
                                      : white,
                                ),
                                Text(
                                  'Test',
                                  style: TextStyle(
                                    fontSize:
                                        smallerNavBarTextSize, //navBarTextSize,
                                    color: _navManager.buttonNotifier.value ==
                                            NavState.test
                                        ? mainSchemeColor
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
                          child: OutlinedButton(
                            onPressed: () {
                              if (_navManager.buttonNotifier.value !=
                                  NavState.test2) {
                                _navManager.testing2();
                                setState(() {});
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.remove_circle,
                                  size: bottomIconSize,
                                  color: _navManager.buttonNotifier.value ==
                                          NavState.test2
                                      ? mainSchemeColor
                                      : white,
                                ),
                                Text(
                                  'Test2',
                                  style: TextStyle(
                                    fontSize:
                                        smallerNavBarTextSize, //navBarTextSize,
                                    color: _navManager.buttonNotifier.value ==
                                            NavState.test2
                                        ? mainSchemeColor
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
                          child: OutlinedButton(
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
                                      ? mainSchemeColor
                                      : white,
                                ),
                                Text(
                                  'Schedule',
                                  style: TextStyle(
                                    fontSize:
                                        smallerNavBarTextSize, //user.isAdmin ? navBarTextSize,
                                    color: _navManager.buttonNotifier.value ==
                                            NavState.schedule
                                        ? mainSchemeColor
                                        : white,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        if (user!.isAdmin)
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
                                        ? mainSchemeColor
                                        : white,
                                  ),
                                  Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontSize:
                                          smallerNavBarTextSize, //user.isAdmin ? navBarTextSize,
                                      color: _navManager.buttonNotifier.value ==
                                              NavState.admin
                                          ? mainSchemeColor
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
      },
    );
  }

  Future<bool> getUser() async {
    user = await User().getUserFromStorage();
    return true;
  }
}
