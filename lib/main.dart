import 'package:flutter/material.dart';
import 'package:my_new_project/services/background_location_service.dart';
import 'package:my_new_project/utils/app_colors.dart';
import 'package:my_new_project/utils/routes/routes.dart';
import 'package:my_new_project/utils/routes/routes_names.dart';
import 'package:my_new_project/viewModel/login_viewmodel.dart';
import 'package:my_new_project/viewmodel/amc_viewmodel.dart';
import 'package:my_new_project/viewmodel/customerReport_viewmodel.dart';
import 'package:my_new_project/viewmodel/customers_viewmodel.dart';
import 'package:my_new_project/viewModel/dashboard_viewmodel.dart';
import 'package:my_new_project/viewmodel/getMenus_viewmodel.dart';
import 'package:my_new_project/viewmodel/map_viewmodel.dart';
import 'package:my_new_project/viewModel/profile_viewmodel.dart';
import 'package:my_new_project/viewmodel/productExpiry_viewmodel.dart';
import 'package:my_new_project/viewmodel/query_viewmodel.dart';
import 'package:my_new_project/viewmodel/tickets_viewmodel.dart';
import 'package:my_new_project/viewmodel/userStatus_viewmodel.dart';
import 'package:my_new_project/viewmodel/workPerformance_viewmodel.dart';
import 'package:my_new_project/viewmodel/workReport_viewmodel.dart';
import 'package:provider/provider.dart';
import 'data/network/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundLocationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => TicketsViewModel()),
        ChangeNotifierProvider(create: (_) => QueryViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => CustomersViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => WorkReportViewModel()),
        ChangeNotifierProvider(create: (_) => WorkPerformanceViewModel()),
        ChangeNotifierProvider(create: (_) => AMCViewModel()),
        ChangeNotifierProvider(create: (_) => UserStatusViewModel()),
        ChangeNotifierProvider(create: (_) => CustomerReportViewModel()),
        ChangeNotifierProvider(create: (_) => ProductExpiryViewModel()),
        ChangeNotifierProvider(create: (_) => GetMenusViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.navigatorKey, // 🔥 ADD THIS LINE
        title: 'flowupS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primary,

          textSelectionTheme: TextSelectionThemeData(
            cursorColor: primary,              // ✅ blinking cursor color
            selectionColor: primary.withOpacity(0.3),
            selectionHandleColor: primary,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: primary,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        initialRoute: RouteNames.splashScreen,
        onGenerateRoute: Routes.generateRoutes,
      ),
    );
  }
}
