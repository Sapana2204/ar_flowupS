import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../model/amc_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/amc_viewmodel.dart';

class AMCReminderDialog extends StatefulWidget {
  final AMCData data;

  const AMCReminderDialog({
    super.key,
    required this.data,
  });

  @override
  State<AMCReminderDialog> createState() =>
      _AMCReminderDialogState();
}

class _AMCReminderDialogState
    extends State<AMCReminderDialog> {
  bool includeReport = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.data;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Send AMC Reminder",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.name ?? "-",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    "EMAIL",
                    item.email ?? "-",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _infoCard(
                    "AMC EXPIRY",
                    item.amcEndDate ?? "-",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    "SUPPORT CALLS",
                    "${item.supportCallCount ?? 0}",
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _infoCard(
                    "PREVIOUS REMINDERS",
                    "${item.reminderCount ?? 0}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _infoCard(
              "PREVIOUS REMINDER DATE",
              item.lastReminderSentAt?.toString() ??
                  "-",
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: includeReport,
                    activeColor: primary,
                    checkColor: Colors.white,
                    side: const BorderSide(
                      color: primary,
                      width: 1.5,
                    ),
                    onChanged: (v) {
                      setState(() {
                        includeReport = v ?? false;
                      });
                    },
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Include report",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Attach Excel support-call report for this AMC period.",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                            Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel", style: TextStyle(color: primary),),
                ),

                const SizedBox(width: 10),

                Consumer<AMCViewModel>(
                  builder: (_, vm, __) {
                    return ElevatedButton.icon(
                      onPressed: vm.isSendingReminder
                          ? null
                          : () async {
                        final success =
                        await vm.sendAMCReminder(
                          customerId: item.customerId ?? 0,
                          includeReport: includeReport,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.reminderMessage),
                          ),
                        );

                        if (success) {
                          Navigator.pop(context);
                          vm.refreshAMC();
                        }
                      },
                      icon: vm.isSendingReminder
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.send),
                      label: Text(
                        vm.isSendingReminder
                            ? "Sending..."
                            : "Send Reminder",
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String value,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}