import 'package:flutter/material.dart';

import '../res/widgets/leadCard.dart';
import '../utils/app_colors.dart';

class LeadsDashboard extends StatelessWidget {
  const LeadsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Leads"),
        backgroundColor: primary,
      ),

      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabs(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                LeadCard(
                  name: "Jonathan Wick",
                  company: "Continental Corp",
                  status: "NEW",
                ),
                SizedBox(height: 16),
                LeadCard(
                  name: "Sarah Jenkins",
                  company: "Tech Solutions",
                  status: "CONTACTED",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search leads by name",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _tab("ALL LEADS", true),
          const SizedBox(width: 8),
          _tab("RECENTLY ADDED", false),
          const SizedBox(width: 8),
          _tab("HIGH PRIORITY", false),
        ],
      ),
    );
  }

  Widget _tab(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }
}