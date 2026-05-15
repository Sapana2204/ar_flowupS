import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [

          /// 🔷 TOP GRADIENT HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 70),
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),

          ),

          /// 👤 PROFILE CARD (OVERLAP EFFECT)
          Transform.translate(
            offset: const Offset(0, -50),
            child: Column(
              children: [

                /// AVATAR (NO EDIT ICON ✅)
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: lightPrimary.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),

                const SizedBox(height: 10),

                /// NAME
                const Text(
                  "Marcus Thorne",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                /// ROLE + DEPT
                Text(
                  "Senior Systems Architect",
                  style: TextStyle(color: primary),
                ),

                const SizedBox(height: 2),

                const Text(
                  "IT Department",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 14),

                /// 🔷 CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      /// CHIPS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _chip(
                            "Active Status",
                            primary.withOpacity(0.1),
                            primary,
                          ),
                          const SizedBox(width: 8),
                          _chip(
                            "ID: 49201",
                            Colors.grey.shade200,
                            Colors.black87,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// STATS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statCard("124", "Resolved"),
                          _statCard("12", "Pending"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔴 SIGN OUT BUTTON (MODERN)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GestureDetector(
              onTap: () => _handleLogout(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.red.shade200),
                  color: Colors.red.shade50,
                ),
                child: const Center(
                  child: Text(
                    "Sign Out of flowupS",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔻 SYSTEM VERSION (NOW BELOW BUTTON)
          const Text(
            "System Version 1.0.0-AF © 2026\nflowupS CallDesk",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.5, // 👈 better line spacing
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 CHIP
  Widget _chip(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }

  /// 🔹 STAT CARD (IMPROVED)
  Widget _statCard(String value, String label) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: lightPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 LOGOUT
  void _handleLogout(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(color: primary),)),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sign Out")),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }
}