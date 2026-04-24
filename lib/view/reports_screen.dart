import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  /// 🔹 FILTER VALUES
  String? selectedClient;
  String? selectedStatus;
  String? selectedAssignedBy;
  String? selectedResolvedBy;
  DateTimeRange? selectedDateRange;

  String searchQuery = "";

  /// 🔹 DUMMY DATA
  List<Map<String, dynamic>> allTickets = [
    {
      "client": "ABC Corp",
      "status": "Open",
      "assignedBy": "Admin",
      "resolvedBy": "",
      "date": DateTime.now().subtract(const Duration(days: 1))
    },
    {
      "client": "XYZ Ltd",
      "status": "Resolved",
      "assignedBy": "Manager",
      "resolvedBy": "Rahul",
      "date": DateTime.now().subtract(const Duration(days: 5))
    },
  ];

  List<Map<String, dynamic>> filteredTickets = [];

  @override
  void initState() {
    super.initState();
    filteredTickets = allTickets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: "excel", child: Text("Export Excel")),
              const PopupMenuItem(value: "pdf", child: Text("Export PDF")),
            ],
            onSelected: (val) {
              if (val == "excel") _exportExcel();
              if (val == "pdf") _exportPDF();
            },
          )
        ],
      ),

      body: Column(
        children: [

          /// 🔍 SEARCH BAR
          const Padding(
            padding: EdgeInsets.all(10),

          ),

          /// 📊 COUNT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${filteredTickets.length} results found",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(height: 5),

          /// 📋 LIST
          Expanded(
            child: filteredTickets.isEmpty
                ? const Center(child: Text("No data found"))
                : ListView.builder(
              itemCount: filteredTickets.length,
                itemBuilder: (context, index) {
                  final ticket = filteredTickets[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [

                        /// 🔹 LEFT ID BOX
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text("ID",
                                  style: TextStyle(fontSize: 10, color: Colors.grey)),
                              Text(
                                "#TK-${index + 100}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 🔹 MAIN CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// TITLE
                              Text(
                                ticket["client"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),

                              const SizedBox(height: 4),

                              /// SUB INFO
                              Row(
                                children: [
                                  const Icon(Icons.business, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    ticket["assignedBy"],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd MMM').format(ticket["date"]),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              /// STATUS BADGE
                              Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(ticket["status"]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  ticket["status"].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔹 RIGHT ARROW
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Open":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// 🔹 FILTER SHEET
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔹 HEADER
                    const Center(
                      child: Text(
                        "Filters",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 GLOBAL SEARCH
                    _sectionTitle("GLOBAL SEARCH"),
                    _textField(
                      hint: "Search by Ticket ID or Keyword...",
                      onChanged: (val) {
                        setModalState(() => searchQuery = val);
                      },
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 DATE RANGE
                    _sectionTitle("DATE RANGE"),
                    Row(
                      children: [
                        Expanded(
                          child: _dateField(
                            selectedDateRange?.start,
                                () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedDateRange = DateTimeRange(
                                    start: picked,
                                    end: selectedDateRange?.end ?? picked,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("TO"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dateField(
                            selectedDateRange?.end,
                                () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedDateRange = DateTimeRange(
                                    start: selectedDateRange?.start ?? picked,
                                    end: picked,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 DROPDOWNS
                    _sectionTitle("CLIENT"),
                    _modernDropdown(
                        "All Clients",
                        ["ABC Corp", "XYZ Ltd"],
                        selectedClient, (val) {
                      setModalState(() => selectedClient = val);
                    }),

                    const SizedBox(height: 12),

                    _sectionTitle("RESOLVED BY"),
                    _modernDropdown(
                        "Any Agent",
                        ["Rahul", "Amit"],
                        selectedResolvedBy, (val) {
                      setModalState(() => selectedResolvedBy = val);
                    }),

                    const SizedBox(height: 12),

                    _sectionTitle("ASSIGNED BY"),
                    _modernDropdown(
                        "Any Manager",
                        ["Admin", "Manager"],
                        selectedAssignedBy, (val) {
                      setModalState(() => selectedAssignedBy = val);
                    }),

                    const SizedBox(height: 12),

                    _sectionTitle("STATUS"),
                    _modernDropdown(
                        "All Statuses",
                        ["Open", "In Progress", "Resolved"],
                        selectedStatus, (val) {
                      setModalState(() => selectedStatus = val);
                    }),

                    const SizedBox(height: 20),

                    /// 🔹 ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedClient = null;
                                selectedStatus = null;
                                selectedAssignedBy = null;
                                selectedResolvedBy = null;
                                selectedDateRange = null;
                                searchQuery = "";
                                filteredTickets = allTickets;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Reset"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters();
                              Navigator.pop(context);
                            },
                            child: const Text("Apply"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 1,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({required String hint, Function(String)? onChanged}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dateField(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null
                  ? "dd-mm-yyyy"
                  : DateFormat('dd-MM-yyyy').format(date),
              style: const TextStyle(fontSize: 13),
            ),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _modernDropdown(String hint, List<String> items, String? value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// 🔹 APPLY FILTERS
  void _applyFilters() {
    filteredTickets = allTickets.where((ticket) {

      final matchesSearch =
      ticket["client"].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesClient =
          selectedClient == null || ticket["client"] == selectedClient;

      final matchesStatus =
          selectedStatus == null || ticket["status"] == selectedStatus;

      final matchesDate = selectedDateRange == null ||
          (ticket["date"].isAfter(selectedDateRange!.start) &&
              ticket["date"].isBefore(selectedDateRange!.end));

      return matchesSearch && matchesClient && matchesStatus && matchesDate;
    }).toList();

    setState(() {});
  }

  /// 🔹 DROPDOWN
  Widget _buildDropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  /// 🔹 EXPORT (BASIC PLACEHOLDER)
  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Excel export coming soon")),
    );
  }

  void _exportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF export coming soon")),
    );
  }
}