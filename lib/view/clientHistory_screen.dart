import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/routes/app_colors.dart';

class ClientHistoryScreen extends StatelessWidget {
  final String clientName;
  final String phone;

  const ClientHistoryScreen({
    super.key,
    required this.clientName,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client History"),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// CLIENT INFO
            Text(
              clientName.isEmpty ? "Unknown Client" : clientName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(phone),

            const SizedBox(height: 20),

            /// HISTORY LIST
            const Text(
              "Previous Calls",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: 5, // replace with API
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("Call #${index + 1}"),
                      subtitle: const Text("Technical Support - Resolved"),
                      trailing: const Text("12 Feb"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}