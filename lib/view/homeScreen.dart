import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_new_project/view/amcList_screen.dart';
import 'package:my_new_project/view/customerList_screen.dart';
import 'package:my_new_project/view/productExpiryReport_screen.dart';
import 'package:my_new_project/view/profile_screen.dart';
import 'package:my_new_project/view/quotationList_screen.dart';
import 'package:my_new_project/view/registerCall_screen.dart';
import 'package:my_new_project/view/workReport_screen.dart';
import 'package:my_new_project/view/userMarker_screen.dart';
import 'package:my_new_project/view/workPerformanceReport_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/network/socket_service.dart';
import '../model/notification_model.dart';
import '../repository/login_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/enums/register_call_mode.dart';
import '../viewModel/login_viewmodel.dart';
import '../viewmodel/userStatus_viewmodel.dart';
import 'dashboard_screen.dart';
import 'loginScreen.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver {
  late int _currentIndex;
  int notificationCount = 0;
  ValueNotifier<List<NotificationModel>> notificationNotifier = ValueNotifier([]);
  final LoginRepository _repo = LoginRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isSignedIn = false;
  bool _locationReady = false;
  bool _checkingLocation = true;
  bool _locationDialogShown = false;

  bool get _canViewReports {
    final role = context.read<LoginViewModel>().userData?.roleSlug
        ?.toLowerCase()
        .trim();

    return role == "admin" || role == "superadmin";
  }


  final List<Widget> _pages = const [
    DashboardScreen(),
    Center(child: Text(AppStrings.ticketsScreen)),
    Center(child: Text(AppStrings.alertsScreen)),
    Center(child: Text(AppStrings.profileScreen)),
  ];

  @override
  @override
  void initState() {
    super.initState();

    print("🔥 HomeScreen initState");

    WidgetsBinding.instance.addObserver(this);

    _currentIndex = widget.initialIndex;

    _initializeHome();
  }

  Future<void> _initializeHome() async {
    final locationAvailable = await _checkLocation();

    if (!mounted) return;

    if (!locationAvailable) {
      setState(() {
        _checkingLocation = false;
        _locationReady = false;
      });

      await _showLocationRequiredDialog();

      return;
    }

    setState(() {
      _checkingLocation = false;
      _locationReady = true;
    });

    // Only load app data after location is available
    _loadAttendanceState();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _locationReady) {
        loadInitialCount();
      }
    });

    SocketService().listenNotification((data) async {
      if (!_locationReady || !mounted) return;

      print("🔥 SOCKET HIT: $data");

      _playNotificationSound();

      setState(() {
        notificationCount += 1;
      });

      final latest = await _repo.fetchNotifications();

      if (mounted) {
        notificationNotifier.value = latest;
      }
    });
  }

  Future<bool> _checkLocation() async {
    try {
      // 1. Check whether GPS/location service is ON
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        print("❌ Location service is OFF");
        return false;
      }

      // 2. Check permission
      LocationPermission permission =
      await Geolocator.checkPermission();

      print("📍 Location permission: $permission");

      // 3. Request permission if not granted
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        print("📍 Requested permission: $permission");
      }

      // 4. User denied permission
      if (permission == LocationPermission.denied) {
        print("❌ Location permission denied");
        return false;
      }

      // 5. User permanently denied permission
      if (permission == LocationPermission.deniedForever) {
        print("❌ Location permission permanently denied");
        return false;
      }

      // 6. Permission granted
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {

        // Extra confirmation that location can actually be obtained
        try {
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
            ),
          );

          print("✅ Location available");
          return true;
        } catch (e) {
          print("❌ Unable to get current location: $e");
          return false;
        }
      }

      return false;
    } catch (e) {
      print("❌ Location check error: $e");
      return false;
    }
  }

  Future<void> _showLocationRequiredDialog() async {
    if (!mounted || _locationDialogShown) return;

    _locationDialogShown = true;

    while (mounted && !_locationReady) {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      final permission =
      await Geolocator.checkPermission();

      if (serviceEnabled &&
          permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final available = await _checkLocation();

        if (available) {
          if (mounted) {
            setState(() {
              _locationReady = true;
              _checkingLocation = false;
            });
          }

          _locationDialogShown = false;
          return;
        }
      }

      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(
              24,
              24,
              24,
              0,
            ),
            contentPadding: const EdgeInsets.fromLTRB(
              24,
              18,
              24,
              10,
            ),
            actionsPadding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16,
            ),
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off_rounded,
                    color: Colors.red.shade700,
                    size: 34,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Location Service Required",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.shade100,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Location service is important to use "
                              "this application.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "It is required to fetch and provide accurate "
                      "data based on your current location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Please enable Location Service and allow "
                      "location permission to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, "exit");
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, "settings");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(
                  Icons.location_on_rounded,
                  size: 19,
                ),
                label: const Text(
                  "Enable Location",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      if (result == "settings") {
        await Geolocator.openLocationSettings();

        await Future.delayed(
          const Duration(milliseconds: 800),
        );

        continue;
      }

      if (result == "exit") {
        _locationDialogShown = false;
        return;
      }
    }

    _locationDialogShown = false;
  }

  /// 🔷 Dynamic Title
  String get _title {
    switch (_currentIndex) {
      case 0:
        return AppStrings.dashboard;
      case 1:
        return AppStrings.tickets;
      case 2:
        return AppStrings.alerts;
      case 3:
        return AppStrings.profile;
      default:
        return AppStrings.appName;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (_checkingLocation) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Checking location...",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_locationReady) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_rounded,
                  size: 70,
                  color: Colors.grey,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Location Required",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Please enable Location services and "
                      "allow location access to use the application.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  onPressed: () async {
                    await _showLocationRequiredDialog();
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text("Enable Location"),
                ),
              ],
            ),
          ),
        ),
      );
    }
      return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: _currentIndex == 0
            ? [
          /// Attendance Status Icon
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: isSignedIn ? "Active" : "Inactive",
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSignedIn
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSignedIn
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: isSignedIn
                      ? Colors.green
                      : Colors.red,
                  size: 22,
                ),
              ),
            ),
          ),

          /// Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: _showNotificationPanel,
              ),

              if (notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ]
            : null,
      ),
      drawer: _buildDrawer(),
      body: _pages[_currentIndex],
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          /// 🔷 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.7)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  // backgroundColor: Colors.transparent,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.cover,
                      width: 56,
                      height: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppStrings.companyName,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Consumer<LoginViewModel>(
                  builder: (context, loginVm, child) {
                    final user = loginVm.userData;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? "Guest",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// ✅ ROLE HERE
                        Text(
                          user?.roleSlug?.toUpperCase() ?? "",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          /// 📋 MENU
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                /// 🔹 MAIN
                _sectionTitle(AppStrings.mainSection),

                _drawerItem(Icons.dashboard, AppStrings.dashboard, 0),

                _drawerSimpleNav(Icons.location_on_outlined, AppStrings.userMarkers, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LiveMapScreen()),
                  );
                }),

                _drawerSimpleNav(Icons.supervised_user_circle_outlined, AppStrings.customers, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomersListScreen()),
                  );
                }),

                // _drawerSimpleNav(Icons.people_alt_sharp, AppStrings.leads, () {
                //   Navigator.pop(context);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const LeadsDashboard()),
                //   );
                // }),

                _drawerSimpleNav(Icons.attach_money, AppStrings.amcmanagement, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AMCListScreen()),
                  );
                }),

                // _drawerSimpleNav(Icons.radio_button_unchecked_outlined, AppStrings.quotation, () {
                //   Navigator.pop(context);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const QuotationListScreen()),
                //   );
                // }),


                _drawerSimpleNav(Icons.person, AppStrings.profile, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                }),



                if (_canViewReports) ...[
                  const Divider(),

                  /// 🔹 REPORTS
                  _sectionTitle(AppStrings.reportsSection),

                  _drawerSimpleNav(
                    Icons.add_chart,
                    AppStrings.reports,
                        () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkReportScreen(),
                        ),
                      );
                    },
                  ),

                  _drawerSimpleNav(
                    Icons.bar_chart,
                    AppStrings.performanceReport,
                        () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerformanceReportScreen(),
                        ),
                      );
                    },
                  ),

                  _drawerSimpleNav(
                    Icons.production_quantity_limits,
                    AppStrings.productExpreports,
                        () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductExpiryReportScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),
                ],

                /// 🔹 OTHERS
                _sectionTitle(AppStrings.othersSection),

                _drawerSimpleNav(Icons.logout, AppStrings.logout, _handleLogout),
              ],
            ),
          ),
        ]
        ,
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _drawerSimpleNav(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(title),
      onTap: onTap,
    );
  }



  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final isSelected = _currentIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? primary : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primary : Colors.black,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: primary.withOpacity(0.1),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _playNotificationSound() async {
    try {
      await _audioPlayer.stop(); // stop previous
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print("❌ Sound error: $e");
    }
  }

  Future<void> _showNotificationPanel() async {
    final loginVm = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    /// Load notifications
    notificationNotifier.value = await _repo.fetchNotifications();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ValueListenableBuilder<List<NotificationModel>>(
                valueListenable: notificationNotifier,
                builder: (_, list, __) {
                  return Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (list.isNotEmpty)
                        GestureDetector(
                          onTap: () async {
                            final success = await loginVm.readAllNotifications();

                            if (!success) return;

                            notificationNotifier.value = list
                                .map(
                                  (e) => NotificationModel(
                                id: e.id,
                                title: e.title,
                                message: e.message,
                                referenceId: e.referenceId,
                                isRead: "y",
                              ),
                            )
                                .toList();

                            setState(() {
                              notificationCount = 0;
                            });
                          },
                          child: Consumer<LoginViewModel>(
                            builder: (_, vm, __) {
                              if (vm.readAllLoading) {
                                return const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              }

                              return const Text(
                                "Read All",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),

              const Divider(),

              Expanded(
                child: ValueListenableBuilder<List<NotificationModel>>(
                  valueListenable: notificationNotifier,
                  builder: (_, list, __) {

                    /// ✅ EMPTY STATE
                    if (list.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "No notifications available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "New updates will appear here",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final item = list[index];

                        return ListTile(
                          tileColor: item.isRead == "n"
                              ? Colors.blue.shade50
                              : null,

                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(item.message),

                          onTap: () async {
                            await _repo.markNotificationAsRead(item.id);

                            final updatedList =
                            notificationNotifier.value.map((e) {
                              if (e.id == item.id) {
                                return NotificationModel(
                                  id: e.id,
                                  title: e.title,
                                  message: e.message,
                                  referenceId: e.referenceId,
                                  isRead: "y",
                                );
                              }
                              return e;
                            }).toList();

                            notificationNotifier.value = updatedList;

                            setState(() {
                              if (notificationCount > 0) {
                                notificationCount--;
                              }
                            });

                            Navigator.pop(context);
                            _openTicket(item.referenceId);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _openTicket(int ticketId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterCallScreen(
          mode: RegisterCallMode.edit,
          ticketId: ticketId,
          clientId: null, // optional (explained below)
        ),
      ),
    );
  }
  Future<void> loadInitialCount() async {
    final count = await _repo.fetchUnreadCount();
    print("🌐 API Count: $count");

    if (!mounted) return;

    setState(() {
      // ✅ Keep higher value
      notificationCount = count > notificationCount
          ? count
          : notificationCount;
    });
  }

  Future<void> _loadAttendanceState() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn =
        prefs.getBool("attendance_signed_in") ?? false;

    setState(() {
      isSignedIn = signedIn;
    });
  }


  void _handleLogout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.logoutTitle),
          content: const Text(AppStrings.logoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(color: primary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(AppStrings.logout),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await context.read<LoginViewModel>().logout(context);
    }
  }



  @override
  void dispose() {
    super.dispose();
  }
}