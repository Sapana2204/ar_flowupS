import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/tickets_model.dart';
import '../utils/app_colors.dart';
import '../utils/enums/register_call_mode.dart';
import '../viewmodel/tickets_viewmodel.dart';

class ClientHistoryScreen extends StatefulWidget {
  final String clientName;
  final String phone;
  final int clientId; // ✅ ADD
  final String? createdDate;
  final RegisterCallMode mode;
  final int? ticketId;

  const ClientHistoryScreen({
    super.key,
    required this.clientName,
    required this.phone,
    required this.clientId,
    this.createdDate, // ✅ ADD
    this.mode = RegisterCallMode.create,
    this.ticketId,

  });

  @override
  State<ClientHistoryScreen> createState() => _ClientHistoryScreenState();
}

class _ClientHistoryScreenState extends State<ClientHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    return DateTime.parse(date).toLocal().toString().split(' ')[0];
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.mode == RegisterCallMode.edit ? 4 : 1,
      vsync: this,
    );

    Future.microtask(() async {

      final vm =
      Provider.of<TicketsViewModel>(
        context,
        listen: false,
      );

      /// 🔹 Client ticket history
      if (widget.clientId != 0) {
        await vm.fetchClientHistory(
          widget.clientId,
        );
      }

      /// 🔹 Comments + Ticket history
      if (widget.mode == RegisterCallMode.edit &&
          widget.ticketId != null) {

        await vm.fetchComments(
          widget.ticketId!,
        );

        await vm.fetchTicketWorkLogs(
          widget.ticketId!,
        );

        await vm.fetchTicketHistory(
          widget.ticketId!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Client History"),
        backgroundColor: primary,
        bottom: TabBar(
          controller: _tabController,
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white, width: 3),
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(text: "Client History"),

            if (widget.mode == RegisterCallMode.edit)
              const Tab(text: "Comments"),

            if (widget.mode == RegisterCallMode.edit)
              const Tab(text: "Work Log"),

            if (widget.mode == RegisterCallMode.edit)
              const Tab(text: "Ticket History"),
          ],
        ),
      ),

      body: widget.clientId == 0
          ? const Center(child: Text("No client selected"))
          : TabBarView(
        controller: _tabController,
        children: [

          /// CLIENT HISTORY
          Column(
            children: [
              _buildClientHeader(),

              _buildCustomerInfo(),

              Expanded(
                child: _buildTicketList(),
              ),
            ],
          ),

          if (widget.mode == RegisterCallMode.edit)
            _buildCommentsScreen(),

          if (widget.mode == RegisterCallMode.edit)
            _buildWorkLogTab(),

          if (widget.mode == RegisterCallMode.edit)
            _buildHistoryTab(),
        ],
      ),
    );
  }

  /// 🔹 HEADER CARD
  Widget _buildClientHeader() {
    return Consumer<TicketsViewModel>(
      builder: (context, vm, child) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: primary,
                    child: const Icon(Icons.phone, color: Colors.white),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.clientName.isNotEmpty)
                          Text(
                            widget.clientName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                        /// ✅ COMPANY NAME
                        if (vm.clientHistoryList.isNotEmpty &&
                            vm.clientHistoryList.first.companyId != null &&
                            vm.clientHistoryList.first.companyId!
                                .trim()
                                .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 14,
                                  color: primary,
                                ),
                                const SizedBox(width: 4),

                                Expanded(
                                  child: Text(
                                    vm.clientHistoryList.first.companyId!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 3),

                        Row(
                          children: [
                            const Icon(
                              Icons.phone_android,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.phone,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  if (widget.createdDate != null && widget.createdDate!.isNotEmpty)
                    Expanded(
                      child: _infoBox(
                        "Member Since",
                        formatDate(widget.createdDate),
                      ),
                    ),
                  const SizedBox(width: 10),

                  /// ✅ DYNAMIC COUNT
                  Expanded(
                    child: _infoBox(
                      "Total Tickets",
                        vm.clientHistoryList.length.toString()                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerInfo() {
    return Consumer<TicketsViewModel>(
      builder: (context, vm, child) {
        if (vm.clientHistoryList.isEmpty) {
          return const SizedBox();
        }

        final customer = vm.clientHistoryList.first;

        return Container(
          margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [

              /// Top Row
              /// Top Row
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      customer.contactPerson ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: customer.activeAmc == "y"
                          ? Colors.green.withOpacity(0.12)
                          : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      customer.activeAmc == "y"
                          ? "AMC Active"
                          : "AMC Inactive",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: customer.activeAmc == "y"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Product Card
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: primary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text(
                            customer.productName ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            "SN: ${customer.productSerialNumber ?? "-"}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Addons
              if ((customer.productAddOns ?? "").isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity:
                          VisualDensity.compact,
                          label: Text(
                            customer.productAddOns!,
                            style:
                            const TextStyle(fontSize: 11),
                          ),
                          backgroundColor:
                          primary.withOpacity(0.08),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 INFO BOX
  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

   /// 🔹 TICKET LIST
    Widget _buildTicketList() {
      return Consumer<TicketsViewModel>(
        builder: (context, vm, child) {
          if (vm.clientHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.clientHistoryList.isEmpty) {
            return const Center(child: Text("No tickets found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.clientHistoryList.length,
            itemBuilder: (context, index) {
              final ticket = vm.clientHistoryList[index];

              return _ticketCard(ticket);
            },
          );
        },
      );
    }

  Widget _buildWorkLogTab() {
    return Consumer<TicketsViewModel>(
      builder: (context, vm, child) {

        if (vm.workLogsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [

            /// Summary Card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Column(
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: _infoBox(
                          "Expected",
                            "${vm.workLogSummary?.expectedMinutes ?? 0} min"
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _infoBox(
                          "Logged",
                            "${vm.workLogSummary?.loggedMinutes ?? 0} min"                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Expanded(
                        child: _infoBox(
                          "Remaining",
                            "${vm.workLogSummary?.remainingMinutes ?? 0} min"                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _infoBox(
                          "Overtime",
                            "${vm.workLogSummary?.overtimeMinutes ?? 0} min"                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 12),
                  //
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 8,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color:
                  //     (vm.workLogSummary?.canAddLog == "Y")                          ? Colors.green.withOpacity(.1)
                  //         : Colors.red.withOpacity(.1),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Text(
                  //     (vm.workLogSummary?.canAddLog == "Y")                          ? "Can Add Work Log"
                  //         : "Work Log Limit Reached",
                  //     style: TextStyle(
                  //       color:
                  //       (vm.workLogSummary?.canAddLog == "Y")                            ? Colors.green
                  //           : Colors.red,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  Text(
                    "Work Logs (${vm.workLogsList.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 5),

            Expanded(
              child: vm.workLogsList.isEmpty
                  ? const Center(
                child: Text("No work logs found"),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                itemCount: vm.workLogsList.length,
                itemBuilder: (context, index) {

                  final log = vm.workLogsList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// LEFT ICON
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.work_history_outlined,
                            color: primary,
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// NAME + MINUTES
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      log.employeeName ?? "-",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${log.spentMinutes ?? 0} min",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              const SizedBox(height: 8),

                              /// DETAILS
                              Text(
                                log.workDetails ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade800,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),

                                  Text(
                                    "${log.workDate ?? ""} • ${log.workTime ?? ""}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      log.workStatus ?? "",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildHistoryTab() {
    return Consumer<TicketsViewModel>(
      builder: (context, vm, child) {

        if (vm.historyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.ticketHistoryList.isEmpty) {
          return const Center(
            child: Text("No history found"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.ticketHistoryList.length,
          itemBuilder: (context, index) {

            final history = vm.ticketHistoryList[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LEFT ICON (smaller)
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange,
                        width: 1.2,
                      ),
                      color: Colors.orange.withOpacity(0.08),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.orange,
                      size: 14,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// RIGHT CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// NAME + TIME (smaller text)
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              history.userName ?? "User",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2D3A4A),
                              ),
                            ),

                            Text(
                              _timeAgo(history.createdDate),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// MESSAGE CARD (compact)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                color: primary.withOpacity(0.25),
                                width: 2,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2D3A4A),
                                height: 1.4,
                              ),
                              children: [

                                TextSpan(
                                  text:
                                  "${history.actionType ?? "Updated"}: ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                TextSpan(
                                  text: history.comment
                                      ?.replaceAll(
                                    RegExp(r'<[^>]*>'),
                                    '',
                                  ) ??
                                      "",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  String _timeAgo(String? date) {

    if (date == null || date.isEmpty) {
      return "";
    }

    final created =
    DateTime.parse(date).toLocal();

    final diff =
    DateTime.now().difference(created);

    if (diff.inDays > 0) {
      return "${diff.inDays}d ago";
    }

    if (diff.inHours > 0) {
      return "${diff.inHours}h ago";
    }

    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m ago";
    }

    return "Just now";
  }

  /// 🔹 COMMENTS TAB
  Widget _buildCommentsScreen() {
    return Consumer<TicketsViewModel>(
      builder: (context, vm, child) {

        return Column(
          children: [

            Expanded(
              child: vm.commentsLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : vm.commentsList.isEmpty
                  ? const Center(
                child: Text("No comments yet"),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: vm.commentsList.length,
                itemBuilder: (context, index) {

                  final comment =
                  vm.commentsList[index];

                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [

                            Text(
                              comment.userName ?? "",
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            Text(
                              comment.createdDate ??
                                  "",
                              style:
                              const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          comment.commentText ?? "",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// ADD COMMENT BOX
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: vm.commentController,
                      decoration: InputDecoration(
                        hintText: "Write comment...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: () async {

                      if (widget.ticketId == null) {
                        return;
                      }

                      final success =
                      await vm.addComment(
                        widget.ticketId!,
                      );

                      if (success) {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Comment added",
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  /// 🔹 TICKET CARD
  Widget _ticketCard(Data ticket) {
    Color statusColor;

    switch (ticket.ticketStatus) {
      case "Open":
        statusColor = Colors.blue;
        break;
      case "In Progress":
        statusColor = Colors.orange;
        break;
      case "Resolved":
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                   ticket.ticketNo ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ticket.ticketStatus ?? "",
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          if ((ticket.queryType ?? "").isNotEmpty)
            _detailRow("Query Type", ticket.queryType!),

          if ((ticket.description ?? "").isNotEmpty)
            _detailRow(
              "Description",
              ticket.description!
                  .replaceAll(RegExp(r'<[^>]*>'), '')
                  .trim(),
            ),

          if ((ticket.assignee ?? "").isNotEmpty)
            _detailRow("Assigned To", ticket.assignee!),

          /// Start + Due date in single row
          if ((ticket.startDate ?? "").isNotEmpty ||
              (ticket.dueDate ?? "").isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [

                  /// Start Date
                  if ((ticket.startDate ?? "").isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Start Date",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formatDate(ticket.startDate),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if ((ticket.startDate ?? "").isNotEmpty &&
                      (ticket.dueDate ?? "").isNotEmpty)
                    const SizedBox(width: 10),

                  /// Due Date
                  if ((ticket.dueDate ?? "").isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.event,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Due Date",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formatDate(ticket.dueDate),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    final vm = Provider.of<TicketsViewModel>(
      context,
      listen: false,
    );

    vm.commentController.clear();

    super.dispose();
  }
}