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
      length: widget.mode == RegisterCallMode.edit ? 3 : 1,
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
              Expanded(
                child: _buildTicketList(),
              ),
            ],
          ),

          /// COMMENTS
          if (widget.mode == RegisterCallMode.edit)
            _buildCommentsScreen(),

          /// TICKET HISTORY
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.clientName.isNotEmpty)
                        Text(
                          widget.clientName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      Text(
                        widget.phone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
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
                      vm.ticketsList.length.toString(),
                    ),
                  ),
                ],
              )
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
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.ticketsList.isEmpty) {
            return const Center(child: Text("No tickets found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.ticketsList.length,
            itemBuilder: (context, index) {
              final ticket = vm.ticketsList[index];

              return _ticketCard(ticket);
            },
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

          if ((ticket.assignee ?? "").isNotEmpty)
            _detailRow("Assigned To", ticket.assignee!),

          if ((ticket.startDate ?? "").isNotEmpty)
            _detailRow("Start Date", formatDate(ticket.startDate)),

          if ((ticket.dueDate ?? "").isNotEmpty)
            _detailRow("Due Date", formatDate(ticket.dueDate)),
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
}