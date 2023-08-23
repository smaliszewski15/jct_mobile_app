import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() {
  runApp(JohnCageTribute());
}

class JohnCageTribute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'root',
      theme: ThemeData(),
      routes: Routes.getroutes,
      onGenerateRoute: (settings) {
        return Routes.generateRoute(settings);
      },
    );
  }
}
