import 'package:flutter/material.dart';
import 'package:my_new_project/view/profile_screen.dart';
import 'package:my_new_project/view/reports_screen.dart';
import '../utils/routes/app_colors.dart';
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

  final List<Widget> _pages = const [
    DashboardScreen(), // 0
    Center(child: Text("Tickets Screen")), // 1
    Center(child: Text("Alerts Screen")), // 2
    Center(child: Text("Profile Screen")), // 3
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  /// 🔷 Dynamic Title
  String get _title {
    switch (_currentIndex) {
      case 0:
        return "Dashboard";
      case 1:
        return "Tickets";
      case 2:
        return "Alerts";
      case 3:
        return "Profile";
      default:
        return "flowupS";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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
                  backgroundColor: Colors.transparent,
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
                  "AR Infotech",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Text(
                  "Sample User",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          /// 📋 MENU
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                /// 🔹 MAIN SECTION
                _sectionTitle("MAIN"),

                _drawerItem(Icons.dashboard, "Dashboard", 0),
                // _drawerItem(Icons.airplane_ticket, "Tickets", 1),
                // _drawerItem(Icons.add_alert, "Alerts", 2),
                _drawerSimpleNav(Icons.person, "Profile", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                }),

                const Divider(),

                /// 🔹 REPORTS SECTION
                _sectionTitle("REPORTS"),

                _drawerSimpleNav(Icons.bar_chart, "Reports", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsScreen()),
                  );
                }),

                const Divider(),

                /// 🔹 SETTINGS SECTION
                _sectionTitle("OTHERS"),

                // _drawerSimple(Icons.settings, "Settings"),
                // _drawerSimple(Icons.help_outline, "Help"),
                _drawerSimpleNav(Icons.logout, "Logout", _handleLogout),
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

  Widget _drawerSimple(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _handleLogout() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(color: primary),),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      /// 🔹 Clear session (if using shared prefs/token)
      // await SharedPreferences.getInstance().then((prefs) => prefs.clear());

      /// 🔹 Navigate to Login Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), // 👈 create this
            (route) => false,
      );
    }
  }
}