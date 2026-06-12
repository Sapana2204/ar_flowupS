class AMCReminderCard extends StatefulWidget {
  final Data data;

  const AMCReminderCard({
    super.key,
    required this.data,
  });

  @override
  State<AMCReminderCard> createState() =>
      _AMCReminderCardState();
}

class _AMCReminderCardState
    extends State<AMCReminderCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.data;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [

            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        item.companyName ??
                            item.name ??
                            "",
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.contactPerson ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      Text(
                        item.mobileNo ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.daysUntilExpiry != null &&
                        item.daysUntilExpiry! <= 30
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${item.daysUntilExpiry ?? 0} Days",
                    style: TextStyle(
                      color: item.daysUntilExpiry !=
                          null &&
                          item.daysUntilExpiry! <=
                              30
                          ? Colors.red
                          : Colors.green,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// STATS
            Row(
              children: [

                Expanded(
                  child: _smallInfo(
                    "Remaining",
                    "${item.remainingCallCount ?? 0}",
                  ),
                ),

                Expanded(
                  child: _smallInfo(
                    "AMC Term",
                    item.amcTermPeriod ?? "-",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ACTIONS
            Row(
              children: [

                Expanded(
                  child: _actionBtn(
                    Icons.call,
                    "Call",
                    Colors.green,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _actionBtn(
                    Icons.notifications,
                    "Reminder",
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _actionBtn(
                    Icons.location_on,
                    "Visit",
                    Colors.blue,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _actionBtn(
                    Icons.history,
                    "History",
                    Colors.purple,
                  ),
                ),
              ],
            ),

            /// EXPANDED DATA
            if (expanded) ...[
              const Divider(height: 24),

              _detailRow(
                "Expected / Month",
                "${item.expectedCallCount ?? item.expCallCount ?? 0}",
              ),

              _detailRow(
                "Done This Month",
                "${item.doneAmcCallCount ?? 0}",
              ),

              _detailRow(
                "Remaining",
                "${item.remainingCallCount ?? 0}",
              ),

              _detailRow(
                "AMC Tickets",
                "${item.amcTicketCount ?? 0}",
              ),

              _detailRow(
                "Visits Scheduled",
                "${item.amcVisitScheduledCount ?? 0}",
              ),

              _detailRow(
                "Visited",
                "${item.amcVisitedCount ?? 0}",
              ),

              _detailRow(
                "Last Reminder",
                item.lastReminderSentAt
                    ?.toString() ??
                    "Never",
              ),

              _detailRow(
                "Reminders Sent",
                "${item.reminderCount ?? 0}",
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _smallInfo(
      String title,
      String value,
      ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
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

  Widget _actionBtn(
      IconData icon,
      String title,
      Color color,
      ) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}