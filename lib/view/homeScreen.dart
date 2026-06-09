import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_new_project/view/customerList_screen.dart';
import 'package:my_new_project/view/leadsDashboard_screen.dart';
import 'package:my_new_project/view/payroll_screen.dart';
import 'package:my_new_project/view/profile_screen.dart';
import 'package:my_new_project/view/registerCall_screen.dart';
import 'package:my_new_project/view/reports_screen.dart';
import 'package:my_new_project/view/userMarker_screen.dart';
import 'package:provider/provider.dart';
import '../data/network/network_api_services.dart';
import '../data/network/socket_service.dart';
import '../model/notification_model.dart';
import '../repository/login_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/enums/register_call_mode.dart';
import '../viewModel/login_viewmodel.dart';
import 'dashboard_screen.dart';
import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  int notificationCount = 0;
  ValueNotifier<List<NotificationModel>> notificationNotifier = ValueNotifier([]);
  final LoginRepository _repo = LoginRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDialogShowing = false;
  StreamSubscription<ServiceStatus>? _locationStatusSub;
  bool isSignedIn = false;
  bool _statusDialogShown = false;


  final List<Widget> _pages = const [
    DashboardScreen(),
    Center(child: Text(AppStrings.ticketsScreen)),
    Center(child: Text(AppStrings.alertsScreen)),
    Center(child: Text(AppStrings.profileScreen)),
  ];

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
    /// ✅ ADD THIS BLOCK HERE
    _locationStatusSub =
        Geolocator.getServiceStatusStream().listen((status) {
          if (status == ServiceStatus.disabled) {
            _showLocationDialog();
          } else if (status == ServiceStatus.enabled) {
            _startLocationTracking(); // ✅ restart tracking automatically
          }
        });

    _currentIndex = widget.initialIndex;

    /// ✅ Delay to ensure everything is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      loadInitialCount();
    });
    SocketService().listenNotification((data) async {
      print("🔥 SOCKET HIT: $data");
      /// 🔊 PLAY SOUND HERE
      _playNotificationSound();
      setState(() {
        notificationCount += 1;
      });

      /// ✅ FETCH LATEST LIST
      final latest = await _repo.fetchNotifications();
      notificationNotifier.value = latest;
      });

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: _currentIndex == 0
            ? [
          /// Attendance Status Icon
          IconButton(
            onPressed: _changeAttendanceStatus,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSignedIn
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSignedIn
                    ? Icons.work_history_rounded
                    : Icons.fingerprint_rounded,
                color: isSignedIn
                    ? Colors.green
                    : Colors.orange,
                size: 22,
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

                _drawerSimpleNav(Icons.people_alt_sharp, AppStrings.leads, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LeadsDashboard()),
                  );
                }),

                // _drawerSimpleNav(Icons.co_present_sharp, AppStrings.payroll, () {
                //   Navigator.pop(context);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const PayrollScreen()),
                //   );
                // }),

                _drawerSimpleNav(Icons.person, AppStrings.profile, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                }),



                const Divider(),

                /// 🔹 REPORTS
                _sectionTitle(AppStrings.reportsSection),

                _drawerSimpleNav(Icons.bar_chart, AppStrings.reports, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsScreen()),
                  );
                }),

                const Divider(),

                /// 🔹 OTHERS
                _sectionTitle(AppStrings.othersSection),

                _drawerSimpleNav(Icons.logout, AppStrings.logout, _handleLogout),
              ],
            ),
          ),
        ],
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

  void _changeAttendanceStatus() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSignedIn
                    ? Icons.logout_rounded
                    : Icons.login_rounded,
                size: 36,
                color: isSignedIn
                    ? Colors.red
                    : Colors.green,
              ),

              const SizedBox(height: 12),

              Text(
                isSignedIn ? "Sign Out" : "Sign In",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                isSignedIn
                    ? "End today's work session?"
                    : "Start today's work session?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actionsPadding:
          const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: () => Navigator.pop(context),
                //     child: const Text(
                //       "Cancel",
                //       style: TextStyle(color: primary),
                //     ),
                //   ),
                // ),
                //
                // const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      setState(() {
                        isSignedIn = !isSignedIn;
                      });

                      // API call here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSignedIn
                          ? Colors.red
                          : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      isSignedIn
                          ? "Sign Out"
                          : "Sign In",
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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

  Future<void> _startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// 🔴 STEP 1: Check if location service is ON
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog();
      return;
    }

    /// 🔴 STEP 2: Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _showLocationDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(openSettings: true);
      return;
    }

    /// Show attendance dialog only once
    if (!_statusDialogShown) {
      _statusDialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _changeAttendanceStatus();
      });
    }

    /// ✅ STEP 3: Start tracking ONLY if allowed
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      ),
    ).listen((Position position) {

      print("📡 LIVE LOCATION UPDATE:");
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");

      NetworkApiServices().getPostApiResponse(
        "/users/update-location",
        {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
      );
    });

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!_statusDialogShown) {
      _statusDialogShown = true;

      Future.delayed(
        const Duration(milliseconds: 500),
            () => _showAttendanceDialog(),
      );
    }
  }

  void _showLocationDialog({bool openSettings = false}) {
    if (_isDialogShowing) return; // 🚫 prevent duplicate

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Required"),
          content: const Text(
            "This app requires location to work. Please enable location services.",
          ),
          actions: [
            if (openSettings)
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                _isDialogShowing = false; // ✅ reset
                _startLocationTracking();
              },
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Attendance"),
          content: const Text(
            "Please select your current status",
          ),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Sign In"),
              onPressed: () async {
                Navigator.pop(context);

                setState(() {
                  isSignedIn = true;
                });

                await _updateAttendance("signin");
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
              onPressed: () async {
                Navigator.pop(context);

                setState(() {
                  isSignedIn = false;
                });

                await _updateAttendance("signout");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAttendance(String status) async {
    try {
      await NetworkApiServices().getPostApiResponse(
        "/users/attendance",
        {
          "status": status, // signin / signout
        },
      );

      print("Attendance Updated: $status");
    } catch (e) {
      print(e);
    }
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _locationStatusSub?.cancel(); // ✅ prevent memory leak
    super.dispose();
  }
}