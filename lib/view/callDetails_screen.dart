import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/updateWorkLog_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/tickets_viewmodel.dart';

class CallDetailsScreen extends StatefulWidget {
  final int workLogId;
  final int ticketId;

  const CallDetailsScreen({
    super.key,
    required this.workLogId,
    required this.ticketId,
  });

  @override
  State<CallDetailsScreen> createState() => _CallDetailsScreenState();
}

class _CallDetailsScreenState extends State<CallDetailsScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TicketsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Call Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Call Completed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Please enter the discussion details before closing the work log.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Call Summary",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: controller,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: "Enter call discussion...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: vm.updateWorkLogLoading
                    ? null
                    : () async {
                  if (controller.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter call details.",
                        ),
                      ),
                    );
                    return;
                  }

                  final success = await vm.updateWorkLog(
                    UpdateWorkLogModel(
                      workLogId: widget.workLogId,
                      ticketId: widget.ticketId,
                      workDetails: controller.text.trim(),
                      workStatus: "completed",
                    ),
                  );

                  if (success && mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: vm.updateWorkLogLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: Text(
                  vm.updateWorkLogLoading
                      ? "Submitting..."
                      : "Submit Details",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}