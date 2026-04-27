import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/app_colors.dart';
import '../utils/routes/routes_names.dart';
import 'clientHistory_screen.dart';

class UpdateCallScreen extends StatefulWidget {
  const UpdateCallScreen({super.key});

  @override
  State<UpdateCallScreen> createState() => _UpdateCallScreenState();
}

class _UpdateCallScreenState extends State<UpdateCallScreen> {

  /// CONTROLLERS
  TextEditingController ownerController =
  TextEditingController(text: "Admin");
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController registeredDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  /// DROPDOWNS
  String selectedCategory = "Technical Support";
  String selectedStatus = "Open";
  String selectedUser = "Support";
  String selectedProduct = "Software";

  List<String> categories = [
    "Technical Support",
    "Billing",
    "Sales",
    "General Inquiry",
  ];

  List<String> statusList = ["Open", "In Progress", "Resolved"];
  List<String> usersList = ["Support", "Admin", "Manager"];
  List<String> productList = ["Software", "Hardware"];

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Update Call"),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 BASIC INFO
            _sectionTitle("CLIENT INFORMATION"),

            _buildTextFieldWithController(
              "Call Owner",
              "Enter owner",
              Icons.person_outline,
              ownerController,
            ),

            const SizedBox(height: 10),

            /// NAME + HISTORY
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildTextFieldWithController(
                    "Client Name",
                    "Enter name",
                    Icons.person,
                    nameController,
                  ),
                ),
                const SizedBox(width: 8),

                SizedBox(
                  height: 58,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.clientHistoryScreen,
                        arguments: {
                          "clientName": nameController.text,
                          "phone": phoneController.text,
                        },
                      );
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.history, color: primary),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// CONTACT WITH RECENT CALLS
            _buildTextFieldWithAction(
              "Client Contact No",
              "+1 (555) 000-000",
              Icons.phone,
              phoneController,
              Icons.history,
              getRecentCalls,
            ),

            const SizedBox(height: 20),

            /// 🔹 TICKET INFO
            _sectionTitle("CALL DETAILS"),

            _buildDropdown(
              "Query Type",
              categories,
              selectedCategory,
                  (val) => setState(() => selectedCategory = val),
            ),

            _buildDropdown(
              "Status",
              statusList,
              selectedStatus,
                  (val) => setState(() => selectedStatus = val),
            ),

            _buildTextFieldWithController(
              "Reason",
              "Enter reason",
              Icons.help_outline,
              reasonController,
            ),

            _buildDropdown(
              "Reassign",
              usersList,
              selectedUser,
                  (val) => setState(() => selectedUser = val),
            ),

            const SizedBox(height: 20),

            /// 🔹 DATES
            _sectionTitle("DATES"),

            _buildDateField("Registered Date", registeredDateController),
            _buildDateField("Due Date", dueDateController),

            if (dueDateController.text.isNotEmpty)
              _remainingWidget(),

            const SizedBox(height: 20),

            /// 🔹 PRODUCT
            _sectionTitle("PRODUCT INFO"),

            _buildDropdown(
              "Product Type",
              productList,
              selectedProduct,
                  (val) => setState(() => selectedProduct = val),
            ),

            _buildTextFieldWithController(
              "Product Serial No",
              "Enter serial",
              Icons.confirmation_number,
              serialController,
            ),

            const SizedBox(height: 20),

            /// 🔹 DESCRIPTION
            _sectionTitle("DESCRIPTION"),
            _buildExpandableDescription(),

            const SizedBox(height: 30),

            /// 🔹 BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Update Call"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 COMMON WIDGETS

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _buildTextFieldWithController(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithAction(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      IconData actionIcon,
      VoidCallback onTap,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: IconButton(
              icon: Icon(actionIcon, color: primary),
              onPressed: onTap,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value,
      Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );

            if (picked != null) {
              controller.text =
                  DateFormat('dd MMM yyyy').format(picked);
              setState(() {});
            }
          },
          decoration: InputDecoration(
            hintText: "Select date",
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _remainingWidget() {
    DateTime dueDate =
    DateFormat('dd MMM yyyy').parse(dueDateController.text);

    final diff = dueDate.difference(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Days Remaining: ${diff.inDays}"),
        Text("Time Remaining: ${diff.inHours % 24} hrs"),
      ],
    );
  }

  Widget _buildExpandableDescription() {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: descriptionController,
          maxLines: isExpanded ? null : 2,
          decoration: const InputDecoration(
            hintText: "Enter description...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// 🔹 RECENT CALLS (same as your register screen)
  Future<bool> requestCallLogPermission() async {
    var status = await Permission.phone.request();
    return status.isGranted;
  }

  Future<void> getRecentCalls() async {
    bool granted = await requestCallLogPermission();

    if (!granted) return;

    Iterable<CallLogEntry> entries = await CallLog.get();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: entries.take(10).map((call) {
            return ListTile(
              title: Text(call.name ?? "Unknown"),
              subtitle: Text(call.number ?? ""),
              onTap: () {
                nameController.text = call.name ?? "";
                phoneController.text = call.number ?? "";
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}