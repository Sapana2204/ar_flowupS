import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/tickets_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/enums/register_call_mode.dart';
import '../../view/ticketDetails_dialogue.dart';
import '../../view/registerCall_screen.dart';

class CallCard extends StatelessWidget {
  final Data ticket;

  const CallCard({
    super.key,
    required this.ticket,
  });

  Color hexToColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.grey;
    }

    try {
      hexColor = hexColor.replaceAll("#", "");

      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }

      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {

    return InkWell(
        borderRadius: BorderRadius.circular(16),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => TicketDetailsDialog(ticket: ticket),
        );
      },
    child: Container(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.clientId ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              _tag(
                ticket.ticketStatus ?? "",
                hexToColor(ticket.statusColor),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.contactNo ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              _tag(
                ticket.ticketPriority ?? "",
                hexToColor(ticket.priorityColor),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              removeHtmlTags(ticket.description ?? ""),
              style: const TextStyle(fontSize: 12),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("START DATE", style: TextStyle(fontSize: 10)),
                  Text(ticket.startDate ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DUE DATE", style: TextStyle(fontSize: 10)),
                  Text(
                    ticket.dueDate ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getDueDateColor(ticket.dueDate),
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterCallScreen(
                        mode: RegisterCallMode.edit,
                        ticketId: ticket.ticketId,
                        clientId: int.tryParse(ticket.clientId ?? "0"),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
    );  }

  Color getDueDateColor(String? date) {
    if (date == null || date.isEmpty) return Colors.green;

    try {
      final due = DateTime.parse(date);
      final today = DateTime.now();

      final dueDateOnly = DateTime(due.year, due.month, due.day);
      final todayOnly = DateTime(today.year, today.month, today.day);

      // 🔴 today or past
      if (dueDateOnly.isBefore(todayOnly) ||
          dueDateOnly.isAtSameMomentAs(todayOnly)) {
        return Colors.red;
      }

      // 🟢 future
      return Colors.green;
    } catch (_) {
      return Colors.green;
    }
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
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