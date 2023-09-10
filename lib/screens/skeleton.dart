import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'concerts_screen.dart';
import 'home_screen.dart';
import 'test_screen.dart';
import 'user_profile.dart';
import '../components/concert_filter.dart';
import '../components/home_drawer.dart';
import '../components/home_state_manager.dart';
import '../components/nav_bar_manager.dart';
import '../utils/colors.dart';
import '../utils/globals.dart';
import '../utils/user.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  late final NavStateManager _navManager;
  late final HomeStateManager _homeManager;
  Future<bool>? done;

  @override
  void initState() {
    super.initState();
    _navManager = NavStateManager();
    _homeManager = HomeStateManager();
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
                          iconSize: 35,
                          onPressed: () =>
                              Scaffold.of(context).openEndDrawer(),
                        );
                      },
                    ),
                  ]
                      : null,
                  leading: _navManager.buttonNotifier.value == NavState.home
                      ? Builder(
                    builder: (context) {
                      return OutlinedButton(
                        onPressed: () =>
                            Scaffold.of(context).openDrawer(),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/default-profile-image.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                      /*return IconButton(
                        icon: Icon(
                          Icons.list,
                          color: searchFieldColor,
                        ),
                        iconSize: 35,
                        onPressed: () =>
                            Scaffold.of(context).openDrawer(),
                      );*/
                    },
                  )
                      : null,
                  centerTitle: true,
                  backgroundColor: black,
                  automaticallyImplyLeading: false,
                ),
                drawer: _navManager.buttonNotifier.value == NavState.home
                    ? HomeDrawer(
                  homeState: _homeManager,
                )
                    : null,
                endDrawer: _navManager.buttonNotifier.value == NavState.concert ?
                  TagFilterDrawer() : null,
                body: ValueListenableBuilder<NavState>(
                    valueListenable: _navManager.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case NavState.home:
                          return HomeScreen(
                            homeManager: _homeManager,
                          );
                        case NavState.concert:
                          return ConcertsScreen();
                        case NavState.test:
                          return TestScreen();
                        case NavState.schedule:
                          return Container();
                        case NavState.admin:
                          return Container();
                      }
                    }),
                bottomNavigationBar: BottomAppBar(
                  color: black,
                  child: SizedBox(
                    height: 80,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                onPressed: () {
                                  if (_navManager.buttonNotifier.value !=
                                      NavState.home) {
                                    _navManager.home();
                                    setState(() {});
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.home,
                                      size: bottomIconSize,
                                      color: _navManager.buttonNotifier.value ==
                                          NavState.home ? mainSchemeColor : white,
                                    ),
                                    Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: navBarTextSize,
                                        color: _navManager.buttonNotifier.value ==
                                            NavState.home ? mainSchemeColor : white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(10),
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
                                          NavState.concert ? mainSchemeColor : white,
                                    ),
                                    Text(
                                      'Concerts',
                                      style: TextStyle(
                                        fontSize: navBarTextSize,
                                        color: _navManager.buttonNotifier.value ==
                                            NavState.concert ? mainSchemeColor : white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*Expanded(
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
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: <Widget>[
                                  Icon(
                                    Icons.remove_done,
                                    size: bottomIconSize,
                                    color: mainSchemeColor,
                                  ),
                                  Text(
                                    'Test',
                                    style: TextStyle(
                                      fontSize: navBarTextSize,
                                      color: mainSchemeColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              ),
                            ),*/
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(10),
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
                                          NavState.schedule ? mainSchemeColor : white,
                                    ),
                                    Text(
                                      'Schedule',
                                      style: TextStyle(
                                        fontSize: navBarTextSize,
                                        color: _navManager.buttonNotifier.value ==
                                            NavState.schedule ? mainSchemeColor : white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (user!.isAdmin)
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.all(10),
                                child: OutlinedButton(
                                  onPressed: null,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.construction,
                                        size: bottomIconSize,
                                        color: _navManager.buttonNotifier.value ==
                                            NavState.admin ? mainSchemeColor : white,
                                      ),
                                      Text(
                                        'Admin',
                                        style: TextStyle(
                                          fontSize: navBarTextSize,
                                          color: _navManager.buttonNotifier.value ==
                                              NavState.admin ? mainSchemeColor : white,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
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
