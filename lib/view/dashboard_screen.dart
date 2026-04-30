import 'package:flutter/material.dart';
import 'package:my_new_project/view/searchCall_screen.dart';
import 'package:my_new_project/view/updateCall_screen.dart';
import 'package:my_new_project/view/registerCall_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/routes/routes_names.dart';
import 'callsList_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔷 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.welcome,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.searchCallScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.search, color: primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              )
            ],
          ),

          const SizedBox(height: 5),

          Text(
            AppStrings.dashboardSubtitle,
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),

          const SizedBox(height: 20),

          /// 🔘 ACTION BUTTONS
          Row(
            children: [
              _actionButton(
                Icons.call,
                AppStrings.manageCall,
                    () {
                  Navigator.pushNamed(context, RouteNames.callListScreen);
                },
              ),

            ],
          ),

          const SizedBox(height: 20),

          /// 📅 FILTER
          Row(
            children: [
              _chip(AppStrings.yesterday, false),
              const SizedBox(width: 8),
              _chip(AppStrings.today, true),
              const SizedBox(width: 8),
              _chip(AppStrings.tomorrow, false),
            ],
          ),

          const SizedBox(height: 20),

          /// 📊 STATUS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.filteredStatus,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statusBox("24", AppStrings.open),
                    _statusBox("12", AppStrings.active),
                    _statusBox("158", AppStrings.closed),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 📈 GRAPH CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.assignedCalls,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withOpacity(0.2),
                    ),
                    child: const Center(
                      child: Text(
                        "194",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text("● " + AppStrings.open),
                    Text("● " + AppStrings.active),
                    Text("● " + AppStrings.closed),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 Buttons
  Widget _actionButton(IconData icon, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏷 Chips
  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  /// 📊 Status Box
  Widget _statusBox(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  /// 📦 Card Style
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        )
      ],
    );
  }


}