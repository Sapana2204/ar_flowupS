import 'package:flutter/material.dart';

import '../../model/quotation_model.dart';
import '../../utils/app_colors.dart';

class QuotationCard extends StatelessWidget {
  final QuotationModel quotation;
  final VoidCallback? onEdit;
  final VoidCallback? onView;

  const QuotationCard({
    super.key,
    required this.quotation,
    this.onEdit,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onView,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Customer Name + Status
            Row(
              children: [

                Expanded(
                  child: Text(
                    quotation.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _statusTag(quotation.status),
              ],
            ),

            const SizedBox(height: 5),

            /// Firm Name + Amount
            Row(
              children: [

                Expanded(
                  child: Text(
                    quotation.firmName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),

                _amountTag(quotation.quotedRate),
              ],
            ),

            const SizedBox(height: 10),

            /// Contact + Quotation No
            Row(
              children: [

                const Icon(
                  Icons.call,
                  size: 16,
                  color: Colors.grey,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    quotation.contactNo,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                Text(
                  quotation.quotationNo,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Address
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 18,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      quotation.address,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// Dates + Amount
            Row(
              children: [

                Expanded(
                  child: _info(
                    "Quotation Date",
                    quotation.quotationDate,
                  ),
                ),

                Expanded(
                  child: _info(
                    "Due Date",
                    quotation.dueDate,
                    color: getDueDateColor(
                      quotation.dueDate,
                    ),
                  ),
                ),

                Expanded(
                  child: _info(
                    "Quoted Rate",
                    "₹${quotation.quotedRate.toStringAsFixed(0)}",
                    color: Colors.green,
                  ),
                ),

                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(
      String title,
      String value, {
        Color color = Colors.black,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _amountTag(double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "₹${amount.toStringAsFixed(0)}",
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _statusTag(String status) {

    Color color = Colors.orange;

    switch (status.toLowerCase()) {

      case "approved":
        color = Colors.green;
        break;

      case "rejected":
        color = Colors.red;
        break;

      case "pending":
        color = Colors.orange;
        break;

      case "draft":
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
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
          fontSize: 10,
        ),
      ),
    );
  }

  Color getDueDateColor(String date) {

    try {

      final due = DateTime.parse(
        _convertDate(date),
      );

      final today = DateTime.now();

      final dueDate = DateTime(
        due.year,
        due.month,
        due.day,
      );

      final current = DateTime(
        today.year,
        today.month,
        today.day,
      );

      if (dueDate.isBefore(current) ||
          dueDate.isAtSameMomentAs(current)) {
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