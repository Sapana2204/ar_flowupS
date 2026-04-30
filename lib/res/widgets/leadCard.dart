import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class LeadCard extends StatelessWidget {
  final String name;
  final String company;
  final String status;

  const LeadCard({
    super.key,
    required this.name,
    required this.company,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case "NEW":
        return Colors.blue;
      case "CONTACTED":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.business, size: 30),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(),
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            company,
            style: const TextStyle(color: Colors.grey),
          ),

          const Divider(height: 20),

          const Row(
            children: [
              Icon(Icons.email, size: 16),
              SizedBox(width: 5),
              Text("Web Inquiry"),
              SizedBox(width: 20),
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 5),
              Text("2 hours ago"),
            ],
          ),

          const SizedBox(height: 10),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View Details",
                style: TextStyle(color: primary),
              ),
              Icon(Icons.arrow_forward, color: primary),
            ],
          )
        ],
      ),
    );
  }
}