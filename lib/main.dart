import 'package:flutter/material.dart';
import 'package:my_new_project/utils/routes/app_colors.dart';
import 'package:my_new_project/utils/routes/routes.dart';
import 'package:my_new_project/utils/routes/routes_names.dart';
import 'package:my_new_project/viewModel/login_viewmodel.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),

      ],
      child: MaterialApp(
        title: 'SoulConnect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primary,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: primary,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
        initialRoute: RouteNames.splashScreen,
        onGenerateRoute: Routes.generateRoutes,
      ),
    );
  }
}
