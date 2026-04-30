import 'package:flutter/material.dart';
import 'package:my_new_project/utils/routes/routes_names.dart';
import 'package:my_new_project/view/callsList_screen.dart';
import 'package:my_new_project/view/clientHistory_screen.dart';
import 'package:my_new_project/view/dashboard_screen.dart';
import 'package:my_new_project/view/leadsDashboard_screen.dart';
import 'package:my_new_project/view/profile_screen.dart';
import 'package:my_new_project/view/registerCall_screen.dart';
import 'package:my_new_project/view/reports_screen.dart';
import 'package:my_new_project/view/searchCall_screen.dart';
import 'package:my_new_project/view/updateCall_screen.dart';

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

      // case (RouteNames.getStartedScreen):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const getStartedScreen());

      case (RouteNames.dashboardScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DashboardScreen());

      // case (RouteNames.welcomeScreen):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const WelcomeScreen());

      case (RouteNames.callListScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const CallsListScreen());

      case (RouteNames.clientHistoryScreen):
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (BuildContext context) => ClientHistoryScreen(
            clientName: args["clientName"] ?? "",
            phone: args["phone"] ?? "",
            clientId: args["clientId"] ?? 0,
            createdDate: args["createdDate"], // ✅ ADD
          ),
        );

      case (RouteNames.profileScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());

      case (RouteNames.registerCallScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterCallScreen());

      case (RouteNames.reportsScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReportsScreen());

      case (RouteNames.searchCallScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const SearchCallScreen());

      case (RouteNames.updateCallScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const UpdateCallScreen());

      case (RouteNames.leadsScreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeadsDashboard());

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
