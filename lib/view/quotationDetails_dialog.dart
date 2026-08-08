import 'package:flutter/material.dart';

import '../model/quotation_model.dart';
import '../utils/app_colors.dart';

class QuotationDetailsDialog extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationDetailsDialog({
    super.key,
    required this.quotation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Header
              Row(
                children: [

                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xff014AAD),
                    child: Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          quotation.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          quotation.quotationNo,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _statusChip(quotation.status),
                ],
              ),

              const SizedBox(height: 20),

              const Divider(),

              _tile(
                Icons.business,
                "Firm Name",
                quotation.firmName,
              ),

              _tile(
                Icons.call,
                "Contact Number",
                quotation.contactNo,
              ),

              _tile(
                Icons.location_on,
                "Address",
                quotation.address,
              ),

              _tile(
                Icons.calendar_month,
                "Quotation Date",
                quotation.quotationDate,
              ),

              _tile(
                Icons.event_available,
                "Due Date",
                quotation.dueDate,
                valueColor:
                getDueDateColor(quotation.dueDate),
              ),

              _tile(
                Icons.currency_rupee,
                "Quoted Rate",
                "₹ ${quotation.quotedRate.toStringAsFixed(0)}",
                valueColor: Colors.green,
              ),

              _tile(
                Icons.info_outline,
                "Description",
                quotation.description,
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text("Close"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Navigate to Edit Quotation"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
      IconData icon,
      String title,
      String value, {
        Color valueColor = Colors.black,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: primary,
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {

    Color color = Colors.orange;

    switch (status.toLowerCase()) {

      case "approved":
        color = Colors.green;
        break;

      case "rejected":
        color = Colors.red;
        break;

      case "draft":
        color = Colors.blue;
        break;

      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Color getDueDateColor(String date) {
    try {
      final due = DateTime.parse(
        _convertDate(date),
      );

      final now = DateTime.now();

      final dueDate = DateTime(
        due.year,
        due.month,
        due.day,
      );

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      if (dueDate.isBefore(today) ||
          dueDate.isAtSameMomentAs(today)) {
        return Colors.red;
      }

      return Colors.green;
    } catch (_) {
      return Colors.green;
    }
  }

  String _convertDate(String value) {

    final months = {
      "Jan": "01",
      "Feb": "02",
      "Mar": "03",
      "Apr": "04",
      "May": "05",
      "Jun": "06",
      "Jul": "07",
      "Aug": "08",
      "Sep": "09",
      "Oct": "10",
      "Nov": "11",
      "Dec": "12",
    };

    final parts = value.split(" ");

    return "${parts[2]}-${months[parts[1]]}-${parts[0]}";
  }
}