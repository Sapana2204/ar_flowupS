import 'package:flutter/material.dart';
import 'package:my_new_project/utils/routes/routes_names.dart';

import '../../view/homeScreen.dart';
import '../../view/loginScreen.dart';
import '../../view/splash_screen.dart';


class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {

      case (RouteNames.home):
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());

      case (RouteNames.login):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());

      case (RouteNames.splashScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("No route is configured"),
            ),
          ),
        );
    }
  }
}
