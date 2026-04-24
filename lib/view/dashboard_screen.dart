import 'package:flutter/material.dart';
import 'package:my_new_project/view/searchCall_screen.dart';
import 'package:my_new_project/view/updateCall_screen.dart';
import '../utils/routes/app_colors.dart';
import 'package:my_new_project/view/registerCall_screen.dart';


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
                "Welcome",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [

                  /// 🔍 SEARCH BUTTON (Call ID)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchCallScreen(),
                        ),
                      );
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
            "Efficiency is the architect of flow. Here is your current status.",
            style: TextStyle(color: textSecondary, fontSize: 12),
          ),

          const SizedBox(height: 20),

          /// 🔘 ACTION BUTTONS
          Row(
            children: [
              _actionButton(
                Icons.call,
                "Register Call",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterCallScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              _actionButton(
                Icons.upload,
                "Update Call",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpdateCallScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 📅 FILTER
          Row(
            children: [
              _chip("Yesterday", false),
              const SizedBox(width: 8),
              _chip("Today", true),
              const SizedBox(width: 8),
              _chip("Tomorrow", false),
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
                  "Filtered Status",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statusBox("24", "Open"),
                    _statusBox("12", "Active"),
                    _statusBox("158", "Closed"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 📈 GRAPH CARD (SIMPLE PLACEHOLDER)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Assigned Calls Distribution",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                /// Fake chart (replace later with fl_chart)
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

                /// Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text("● Open"),
                    Text("● Active"),
                    Text("● Closed"),
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

  void _showSearchDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search by Call ID"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter Call ID",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String callId = controller.text;

                if (callId.isNotEmpty) {
                  Navigator.pop(context);

                  /// 👉 TODO: Call your API / navigate
                  print("Searching Call ID: $callId");
                }
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }
}