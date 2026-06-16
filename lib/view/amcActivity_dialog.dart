import 'package:flutter/material.dart';
import 'package:my_new_project/model/amcActivity_model.dart';
import '../model/amc_model.dart';

class AMCActivityDialog extends StatelessWidget {
  final AMCActivityModel activity;

  const AMCActivityDialog({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DefaultTabController(
        length: 3,
        child: SizedBox(
          width: double.maxFinite,
          height: 450,
          child: Column(
            children: [

              /// Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AMC Activity",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            activity.customer?.name ?? "",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(
                    text:
                    "Calls (${activity.counts?.calls ?? 0})",
                  ),
                  Tab(
                    text:
                    "Visits (${activity.counts?.visits ?? 0})",
                  ),
                  Tab(
                    text:
                    "Reminders (${activity.counts?.reminders ?? 0})",
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [

                    /// CALLS
                    activity.calls == null ||
                        activity.calls!.isEmpty
                        ? _emptySection("No AMC calls yet")
                        : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: activity.calls!.length,
                      itemBuilder: (_, index) {
                        final call =
                        activity.calls![index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              call.toString(),
                            ),
                          ),
                        );
                      },
                    ),

                    /// VISITS
                    activity.visits == null ||
                        activity.visits!.isEmpty
                        ? _emptySection("No AMC visits yet")
                        : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: activity.visits!.length,
                      itemBuilder: (_, index) {
                        final visit =
                        activity.visits![index];

                        return Card(
                          margin:
                          const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [

                                Text(
                                  visit.ticketNo ?? "",
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 6,
                                ),

                                Text(
                                  visit.visitDetails ??
                                      "",
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  "Status : ${visit.visitStatus ?? '-'}",
                                ),

                                Text(
                                  "Employee : ${visit.employeeName ?? '-'}",
                                ),

                                Text(
                                  "Scheduled : ${visit.visitScheduledAt ?? '-'}",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    /// REMINDERS
                    activity.reminders == null ||
                        activity.reminders!.isEmpty
                        ? _emptySection(
                        "No AMC reminders yet")
                        : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount:
                      activity.reminders!.length,
                      itemBuilder: (_, index) {
                        final reminder =
                        activity.reminders![index];

                        return Card(
                          margin:
                          const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: ListTile(
                            title: Text(
                              reminder.emailSubject ??
                                  "-",
                            ),
                            subtitle: Text(
                              reminder.recipientEmail ??
                                  "-",
                            ),
                            trailing: Text(
                              reminder.status ?? "-",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptySection(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}