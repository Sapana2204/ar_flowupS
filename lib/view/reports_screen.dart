import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/assignee_model.dart';
import '../model/company_model.dart';
import '../viewmodel/workReport_viewmodel.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  /// 🔹 FILTER VALUES
  AssigneeModel? selectedEmployee;
  CompanyModel? selectedCompany;
  String? selectedStatus;
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

    Future.microtask(() async {
      final vm = context.read<WorkReportViewModel>();

      await vm.loadWorkReportData(); // Employee + Company dropdowns

      await vm.getWorkReport(); // Work report data
    });
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
                const PopupMenuItem(
                    value: "excel", child: Text("Export Excel")),
                const PopupMenuItem(value: "pdf", child: Text("Export PDF")),
              ],
              onSelected: (val) {
                if (val == "excel") _exportExcel();
                if (val == "pdf") _exportPDF();
              },
            )
          ],
        ),
        body: Consumer<WorkReportViewModel>(
            builder: (context, dropdownVm, child) {
          return Column(
            children: [
              /// SEARCH BAR (STICKY)
              const Padding(
                padding: EdgeInsets.all(12),
              ),

              /// SUMMARY SECTION (STICKY)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: "Total Logs",
                        value: "29",
                        icon: Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _summaryCard(
                        title: "Total Time",
                        value: "7h 24m",
                        icon: Icons.access_time,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: "Employees",
                        value: "4",
                        icon: Icons.people_outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _summaryCard(
                        title: "Tickets",
                        value: "7",
                        icon: Icons.confirmation_num_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// COMPANY SUMMARY TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: const [
                    Icon(Icons.business),
                    SizedBox(width: 8),
                    Text(
                      "Company Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// COMPANY CARDS (STICKY)
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _companyCard(
                      company: "ABC Inc",
                      time: "5h 47m",
                      logs: "19 logs",
                    ),
                    _companyCard(
                      company: "AR Infotech",
                      time: "1h 18m",
                      logs: "8 logs",
                    ),
                    _companyCard(
                      company: "Others",
                      time: "19m",
                      logs: "2 logs",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ONLY REPORTS SCROLL
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    return _reportCard(filteredTickets[index]);
                  },
                ),
              ),
            ],
          );
        }));
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _companyCard({
    required String company,
    required String time,
    required String logs,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            logs,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportCard(Map<String, dynamic> ticket) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row 1
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  "Date",
                  "09-06-2026",
                ),
              ),
              Expanded(
                child: _infoItem(
                  "Time",
                  "05:14 PM",
                ),
              ),
              Expanded(
                child: _infoItem(
                  "Employee",
                  "Sapana",
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Row 2
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  "Ticket",
                  "TKT-34",
                ),
              ),
              Expanded(
                child: _infoItem(
                  "Client",
                  "Sapana",
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Row 3
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  "Company",
                  "AR Infotech",
                ),
              ),
              Expanded(
                child: _infoItem(
                  "Spent",
                  "2m",
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Work Details",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            ticket["client"] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// 🔹 FILTER SHEET
  void _openFilterSheet() {
    final workReportvm = context.read<WorkReportViewModel>();

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
                    if (workReportvm.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
            else ...[
                    /// 🔹 DROPDOWNS
                    _sectionTitle("EMPLOYEE"),

                    DropdownButtonFormField<AssigneeModel>(
                      value: selectedEmployee,
                      hint: const Text("Select Employee"),
                      items: workReportvm.assigneeList.map((employee) {
                        return DropdownMenuItem<AssigneeModel>(
                          value: employee,
                          child: Text(employee.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedEmployee = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _sectionTitle("COMPANY"),

                    DropdownButtonFormField<CompanyModel>(
                      value: selectedCompany,
                      hint: const Text("Select Company"),
                      items: workReportvm.companyList.map((company) {
                        return DropdownMenuItem<CompanyModel>(
                          value: company,
                          child: Text(company.companyName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCompany = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
],
                    const SizedBox(height: 20),

                    /// 🔹 ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedEmployee = null;
                                selectedCompany = null;                                selectedStatus = null;
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
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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

      final matchesEmployee =
          selectedEmployee == null ||
              ticket["employeeId"] == selectedEmployee!.adminId;

      final matchesCompany =
          selectedCompany == null ||
              ticket["companyId"] == selectedCompany!.companyId;

      final matchesDate = selectedDateRange == null ||
          (ticket["date"].isAfter(selectedDateRange!.start) &&
              ticket["date"].isBefore(selectedDateRange!.end));

      return matchesSearch &&
          matchesEmployee &&
          matchesCompany &&
          matchesDate;    }).toList();

    setState(() {});
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
