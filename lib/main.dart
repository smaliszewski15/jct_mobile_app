import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

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
