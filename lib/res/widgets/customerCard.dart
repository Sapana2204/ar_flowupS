import 'package:flutter/material.dart';
import '../../model/customers_model.dart';
import '../../utils/app_colors.dart';

class CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const CustomerCard({super.key, required this.customer});

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "active":
        return Colors.green;
      case "inactive":
        return Colors.red;
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

          /// 🔹 NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  customer.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _tag(
                customer.status ?? "",
                getStatusColor(customer.status),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 MOBILE + EMAIL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.mobileNo ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Expanded(
                child: Text(
                  customer.email ?? "",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 COMPANY + CUSTOMER ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.companyName ?? "-",
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                "ID: ${customer.customerId ?? "-"}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 ADDRESS BOX
          // if ((customer.address ?? "").isNotEmpty)
          //   Container(
          //     padding: const EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: backgroundColor,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Text(
          //       customer.address ?? "",
          //       style: const TextStyle(fontSize: 12),
          //     ),
          //   ),
          //
          // const SizedBox(height: 12),

          /// 🔹 ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Contact Person (optional)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CONTACT PERSON", style: TextStyle(fontSize: 10)),
                  Text(
                    customer.contactPerson ?? "-",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// Edit Button
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // TODO: Navigate to Edit Customer Screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

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