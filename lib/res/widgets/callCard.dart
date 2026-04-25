import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CallCard extends StatelessWidget {
  final String name;
  final String phone;
  final String status;
  final String priority;
  final String description;
  final String startDate;
  final String dueDate;

  const CallCard({
    super.key,
    required this.name,
    required this.phone,
    required this.status,
    required this.priority,
    required this.description,
    required this.startDate,
    required this.dueDate,
  });

  Color getStatusColor() {
    switch (status) {
      case "NEW":
        return Colors.blue;
      case "IN PROGRESS":
        return Colors.orange;
      case "CLOSED":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Color getPriorityColor() {
    switch (priority) {
      case "HIGH":
        return Colors.red;
      case "MEDIUM":
        return Colors.amber;
      case "LOW":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔝 NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              _tag(status, getStatusColor()),
            ],
          ),

          const SizedBox(height: 4),

          /// 📞 PHONE + PRIORITY
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phone,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              _tag(priority, getPriorityColor()),
            ],
          ),

          const SizedBox(height: 10),

          /// 💬 DESCRIPTION
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              description,
              style: const TextStyle(fontSize: 12),
            ),
          ),

          const SizedBox(height: 12),

          /// 📅 DATES + BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("START DATE", style: TextStyle(fontSize: 10)),
                  Text(startDate,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DUE DATE", style: TextStyle(fontSize: 10)),
                  Text(
                    dueDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),

              // /// 🔘 VIEW BUTTON
              // OutlinedButton(
              //   style: OutlinedButton.styleFrom(
              //     side: BorderSide(color: primary),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              //   onPressed: () {},
              //   child: Text(
              //     "View Details",
              //     style: TextStyle(color: primary),
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }

  /// 🔹 TAG WIDGET
  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}