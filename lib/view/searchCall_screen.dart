import 'package:flutter/material.dart';
import '../utils/routes/app_colors.dart';

class SearchCallScreen extends StatelessWidget {
  const SearchCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Search by ID"),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// 🔍 SEARCH FIELD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Enter Call ID...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔘 FILTER BUTTONS
            Row(
              children: [
                _filterButton("Call ID", true),
                const SizedBox(width: 10),
                _filterButton("Client ID", false),
              ],
            ),

            const SizedBox(height: 20),

            /// 📄 RESULT LIST
            Expanded(
              child: ListView(
                children: [
                  _resultCard(),
                  _resultCard(),
                  _resultCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔘 FILTER BUTTON
  Widget _filterButton(String text, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 📦 RESULT CARD (UPDATED FIELDS)
  Widget _resultCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔝 CLIENT NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Client: ABC Traders",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _statusChip("PENDING"),
            ],
          ),

          const SizedBox(height: 8),

          /// 📞 CONTACT
          const Text("Contact: 9876543210"),

          const SizedBox(height: 6),

          /// ❓ QUERY
          const Text("Query: Server not working"),

          const SizedBox(height: 6),

          /// 📅 DUE DATE
          const Text("Due Date: 25 Oct 2023"),

          const SizedBox(height: 6),

          /// 📝 REASON
          const Text("Reason: Waiting for technician"),

        ],
      ),
    );
  }

  /// 🎯 STATUS CHIP
  Widget _statusChip(String status) {
    Color color;

    switch (status) {
      case "PENDING":
        color = Colors.orange;
        break;
      case "COMPLETED":
        color = Colors.green;
        break;
      case "CANCELLED":
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}