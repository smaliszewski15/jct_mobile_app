import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'concerts_screen.dart';
import 'home_screen.dart';
import 'groups_screen.dart';
import 'test_screen.dart';
import 'user_profile.dart';
import '../components/group_filter.dart';
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
              return const Center(
                  child: CircularProgressIndicator()
              );
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
                  actions: _navManager.buttonNotifier.value == NavState.profile && user!.logged == true ? <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.logout_outlined,
                        color: invalidColor,
                      ),
                      iconSize: 35,
                      onPressed: () async {
                        try {
                          user = await user!.logout();
                          setState(() {});
                        } catch (e) {
                          print("No user logged in!");
                        }
                      },
                    ),
                  ] : (_navManager.buttonNotifier.value == NavState.group ?
                  <Widget>[
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: invalidColor,
                          ),
                          iconSize: 35,
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        );
                      },
                    ),
                  ] : null),
                  leading: _navManager.buttonNotifier.value == NavState.home ?
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(
                            Icons.list,
                            color: searchFieldColor,
                          ),
                          iconSize: 35,
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      },
                    ) : null,
                  centerTitle: true,
                  backgroundColor: black,
                  automaticallyImplyLeading: false,
                ),
                drawer: _navManager.buttonNotifier.value == NavState.home ? HomeDrawer(homeState: _homeManager,) : null,
                endDrawer: _navManager.buttonNotifier.value == NavState.group ? FilterDrawer() : null,
                body: ValueListenableBuilder<NavState>(
                    valueListenable: _navManager.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case NavState.home:
                          return HomeScreen(homeManager: _homeManager,);
                        case NavState.concert:
                          return ConcertsScreen();
                        case NavState.test:
                          return TestScreen();
                        case NavState.group:
                          return GroupsScreen();
                        case NavState.profile:
                          return UserProfilePage();
                        case NavState.admin:
                          return Container();
                      }
                    }
                ),
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
                                  decoration: _navManager.buttonNotifier
                                      .value ==
                                      NavState.home ? lit : null,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (_navManager.buttonNotifier.value !=
                                          NavState.home) {
                                        _navManager.home();
                                        setState(() {});
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.home,
                                          size: bottomIconSize,
                                          color: mainSchemeColor,
                                        ),
                                        Text(
                                          'Home',
                                          style: TextStyle(
                                            fontSize: navBarTextSize,
                                            color: mainSchemeColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: _navManager.buttonNotifier.value ==
                                    NavState.concert ? lit : null,
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
                                        color: mainSchemeColor,
                                      ),
                                      Text(
                                        'Concerts',
                                        style: TextStyle(
                                          fontSize: navBarTextSize,
                                          color: mainSchemeColor,
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
                              child: Container(
                                  decoration: _navManager.buttonNotifier
                                      .value ==
                                      NavState.test ? lit : null,
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
                                  )
                              ),
                            ),*/
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: _navManager.buttonNotifier.value ==
                                    NavState.group ? lit : null,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (_navManager.buttonNotifier.value !=
                                        NavState.group) {
                                      _navManager.groups();
                                      setState(() {});
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.groups,
                                        size: bottomIconSize,
                                        color: mainSchemeColor,
                                      ),
                                      Text(
                                        'Groups',
                                        style: TextStyle(
                                          fontSize: navBarTextSize,
                                          color: mainSchemeColor,
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
                                  decoration: _navManager.buttonNotifier
                                      .value ==
                                      NavState.profile ? lit : null,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (_navManager.buttonNotifier.value !=
                                          NavState.profile) {
                                        _navManager.profile();
                                        setState(() {});
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Center(
                                          child: Icon(
                                            Icons.person,
                                            size: bottomIconSize,
                                            color: mainSchemeColor,
                                          ),
                                        ),
                                        Text(
                                          'Profile',
                                          style: TextStyle(
                                            fontSize: navBarTextSize,
                                            color: mainSchemeColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            ),
                            if (user != null && user!.isAdmin)
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: _navManager.buttonNotifier
                                      .value ==
                                      NavState.admin ? lit : null,
                                  child: OutlinedButton(
                                    onPressed: null,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.construction,
                                          size: bottomIconSize,
                                          color: mainSchemeColor,
                                        ),
                                        Text(
                                          'Admin',
                                          style: TextStyle(
                                            fontSize: navBarTextSize,
                                            color: mainSchemeColor,
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
                      )
                  ),
                ),
                floatingActionButton: _navManager.buttonNotifier.value ==
                    NavState.group ? FloatingActionButton.large(
                  onPressed: null,
                  tooltip: "Create a Group",
                  backgroundColor: mainSchemeColor,
                  foregroundColor: black,
                  child: const Icon(Icons.add, size: 100),
                ) : null,
              );
          }
        }
    );
  }

  Future<bool> getUser() async {
    user = await User().getUserFromStorage();
    return true;
  }
}
