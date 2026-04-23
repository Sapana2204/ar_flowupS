import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/routes/app_colors.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    DashboardScreen(), // ✅ index 0
    Center(child: Text("Tickets Screen")),
    Center(child: Text("Alerts Screen")),
    Center(child: Text("Profile Screen")),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("flowupS"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.grid_view),
        //     onPressed: () => _showQuickActions(),
        //   )
        // ],
      ),

      drawer: _buildDrawer(),

      body: _pages[_currentIndex],

      bottomNavigationBar: _bottomBar(),
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [

          /// 🔷 MODERN HEADER
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
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.business, size: 30),
                ),
                SizedBox(height: 10),
                Text(
                  "Firm Name",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "Role Name",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          /// 📋 MENU LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [

                /// Dashboard
                _drawerItem(
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  onTap: () {
                    setState(() => _currentIndex = 0);
                    Navigator.pop(context);
                  },
                ),

                /// 📊 REPORTS (NEW)
                _expansionTile(
                  icon: Icons.bar_chart,
                  title: "Reports",
                  children: [
                    _subItem("Client Wise", () {
                      Navigator.pop(context);
                    }),
                    _subItem("Resolved By", () {
                      Navigator.pop(context);
                    }),
                    _subItem("Assigned By", () {
                      Navigator.pop(context);
                    }),
                    _subItem("Status Wise", () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primary),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _expansionTile({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: primary),
      title: Text(title),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: children,
    );
  }

  Widget _subItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  // ---------------- BOTTOM BAR ----------------
  Widget _bottomBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [

            /// 🔳 BACKGROUND BAR
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                /// LEFT + RIGHT ITEMS
                child: Row(
                  children: [
                    /// LEFT
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _modernNavItem(Icons.dashboard, "Dashboard", 0),
                          _modernNavItem(Icons.airplane_ticket, "Tickets", 1),
                        ],
                      ),
                    ),

                    const SizedBox(width: 60),

                    /// RIGHT
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _modernNavItem(Icons.add_alert, "Alerts", 2),
                          _modernNavItem(Icons.person, "Profile", 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔵 CENTER BUTTON
            // Positioned(
            //   top: -15,
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() => _currentIndex = 2);
            //     },
            //     child: Container(
            //       height: 60,
            //       width: 60,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         gradient: LinearGradient(
            //           colors: [
            //             primary,
            //             primary.withOpacity(0.8),
            //           ],
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.blue.withOpacity(0.4),
            //             blurRadius: 12,
            //             offset: const Offset(0, 5),
            //           ),
            //         ],
            //       ),
            //       child: const Icon(
            //         Icons.grid_view_rounded,
            //         color: Colors.white,
            //         size: 26,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _modernNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _currentIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? primary : Colors.grey,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? primary : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}