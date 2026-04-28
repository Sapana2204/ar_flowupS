import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/ticket_model.dart';
import '../model/tickets_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/tickets_viewmodel.dart';

class ClientHistoryScreen extends StatefulWidget {
  final String clientName;
  final String phone;
  final int clientId; // ✅ ADD
  final String? createdDate;

  const ClientHistoryScreen({
    super.key,
    required this.clientName,
    required this.phone,
    required this.clientId,
    this.createdDate, // ✅ ADD
  });

  @override
  State<ClientHistoryScreen> createState() => _ClientHistoryScreenState();
}

class _ClientHistoryScreenState extends State<ClientHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String formatDate(String? date) {
    if (date == null) return "-";
    return DateTime.parse(date).toLocal().toString().split(' ')[0];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      Provider.of<TicketsViewModel>(context, listen: false)
          .fetchClientHistory(widget.clientId);
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
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white, width: 3),
            ),
          ),
          labelColor: Colors.white,              // ✅ active tab text
          unselectedLabelColor: Colors.white70,  // ✅ inactive tab text

          tabs: const [
            Tab(text: "Client History"),
            Tab(text: "Comments"),
            Tab(text: "Ticket History"),
          ],
        ),
      ),

      body: Column(
        children: [
          /// 🔹 TOP CLIENT CARD
          _buildClientHeader(),

          /// 🔹 TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTicketList(),
                _buildComments(),
                _buildTicketList(),
              ],
            ),
          ),
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
                      Text(
                        widget.clientName.isEmpty
                            ? "Unknown Client"
                            : widget.clientName,
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
                  Expanded(child:
                  _infoBox(
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

  /// 🔹 COMMENTS TAB
  Widget _buildComments() {
    return const Center(
      child: Text("No comments yet"),
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
                  ticket.ticketNo ?? "No Ticket No",
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

          _detailRow("Query Type", ticket.queryType ?? ""),
          _detailRow("Assigned To", ticket.assignee ?? ""),
          _detailRow("Start Date", formatDate(ticket.startDate)),
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