import 'package:flutter/material.dart';
import '../model/ticket_model.dart';
import '../utils/routes/app_colors.dart';

class ClientHistoryScreen extends StatefulWidget {
  final String clientName;
  final String phone;

  const ClientHistoryScreen({
    super.key,
    required this.clientName,
    required this.phone,
  });

  @override
  State<ClientHistoryScreen> createState() => _ClientHistoryScreenState();
}

class _ClientHistoryScreenState extends State<ClientHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Ticket> tickets = [
    Ticket(
      title: "Issue Raised while adding Sales Entry",
      status: "In Progress",
      category: "Sales",
      assignedBy: "Admin",
      assignedTo: "Sapana",
      resolvedBy: "-",
      resolvedOn: "-",
    ),
    Ticket(
      title: "Login issue",
      status: "Open",
      category: "Authentication",
      assignedBy: "Admin",
      assignedTo: "Support",
      resolvedBy: "-",
      resolvedOn: "-",
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
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
              Expanded(child: _infoBox("Member Since", "Jan 30, 2025")),
              const SizedBox(width: 10),
              Expanded(child: _infoBox("Total Tickets", "2")),
            ],
          )
        ],
      ),
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
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        return _ticketCard(tickets[index]);
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
  Widget _ticketCard(Ticket ticket) {
    Color statusColor;

    switch (ticket.status) {
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

          /// 🔹 TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ticket.title,
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
                  ticket.status,
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 DETAILS
          _detailRow("Category", ticket.category),
          _detailRow("Assigned By", ticket.assignedBy),
          _detailRow("Assigned To", ticket.assignedTo),
          _detailRow("Resolved By", ticket.resolvedBy),
          _detailRow("Resolved On", ticket.resolvedOn),
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