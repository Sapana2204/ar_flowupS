import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';
import '../viewmodel/query_viewmodel.dart';
import 'clientHistory_screen.dart';


class RegisterCallScreen extends StatefulWidget {
  const RegisterCallScreen({super.key});

  @override
  State<RegisterCallScreen> createState() => _RegisterCallScreenState();
}

class _RegisterCallScreenState extends State<RegisterCallScreen> {
  String priority = "Medium";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = Provider.of<QueryViewModel>(context, listen: false);
      vm.fetchQueryTypes();
      vm.fetchPriorityLevels(); // ✅ ADD THIS
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Register Call"),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CLIENT INFO
            const Text(
              "CLIENT INFORMATION",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end, // 👈 important
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
                  height: 58, // 👈 match TextField height
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClientHistoryScreen(
                            clientName: nameController.text,
                            phone: phoneController.text,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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

            _buildTextFieldWithAction(
              "Client Contact No",
              "+1 (555) 000-000",
              Icons.phone,
              phoneController,
              Icons.history, // change icon
              getRecentCalls, // use new function
            ),

            const SizedBox(height: 20),

            /// CALL DETAILS
            const Text(
              "CALL DETAILS",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// PRIORITY
            _buildPriorityDropdown(),


            const SizedBox(height: 15),

            /// ASSIGN TO
            const Text("Assign To"),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: "Sarah Jenkins (Support)",
                  items: const [
                    DropdownMenuItem(
                      value: "Sarah Jenkins (Support)",
                      child: Text("Sarah Jenkins (Support)"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// DESCRIPTION
            const Text("Description"),
            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Briefly describe the call outcome or client needs",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text("Register Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> requestCallLogPermission() async {
    var status = await Permission.phone.request();
    return status.isGranted;
  }

  String formatCallTime(int? timestamp) {
    if (timestamp == null) return "";

    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  Future<void> getRecentCalls() async {
    bool granted = await requestCallLogPermission();

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Call log permission denied")),
      );
      return;
    }

    Iterable<CallLogEntry> entries = await CallLog.get();

    List<CallLogEntry> recentCalls = entries.take(10).toList();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: recentCalls.length,
          itemBuilder: (context, index) {
            final call = recentCalls[index];

            return ListTile(
              title: Text(call.name ?? "Unknown"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(call.number ?? "No number"),
                  const SizedBox(height: 2),
                  Text(
                    formatCallTime(call.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    getCallIcon(call.callType),
                    color: getCallColor(call.callType),
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(getCallLabel(call.callType)),
                ],
              ),
              onTap: () {
                setState(() {
                  nameController.text = call.name ?? "";
                  phoneController.text = call.number ?? "";
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  IconData getCallIcon(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.rejected:
        return Icons.call_end;
      default:
        return Icons.phone;
    }
  }

  Color getCallColor(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blue;
      case CallType.missed:
        return Colors.red;
      case CallType.rejected:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String getCallLabel(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return "Incoming";
      case CallType.outgoing:
        return "Outgoing";
      case CallType.missed:
        return "Missed";
      case CallType.rejected:
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  Future<void> pickContact() async {
    try {
      final contact = await _contactPicker.selectContact();

      if (contact != null) {

        /// ✅ Set name first
        nameController.text = contact.fullName ?? "";

        /// ✅ MULTIPLE NUMBERS → SHOW SELECTION UI
        if (contact.phoneNumbers != null &&
            contact.phoneNumbers!.length > 1) {

          showModalBottomSheet(
            context: context,
            builder: (_) {
              return ListView(
                children: contact.phoneNumbers!.map((number) {
                  return ListTile(
                    title: Text(number),
                    onTap: () {
                      setState(() {
                        phoneController.text = number;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          );
        }

        /// ✅ SINGLE NUMBER
        else if (contact.phoneNumbers != null &&
            contact.phoneNumbers!.isNotEmpty) {
          setState(() {
            phoneController.text = contact.phoneNumbers!.first;
          });
        }

        /// ❌ NO NUMBER
        else {
          setState(() {
            phoneController.text = "";
          });
        }
      }
    } catch (e) {
      debugPrint("Error picking contact: $e");
    }
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
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true, // 🔥 reduces height
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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

  Widget _buildPriorityDropdown() {
    return Consumer<QueryViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Priority Level"),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),

              child: vm.isLoading
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              )
                  : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: vm.priorityList.any(
                          (e) => e.categoryName == vm.selectedPriority)
                      ? vm.selectedPriority
                      : null,
                  hint: const Text("Select Priority"),
                  isExpanded: true,

                  items: vm.priorityList.map((item) {
                    return DropdownMenuItem(
                      value: item.categoryName,
                      child: Text(item.categoryName ?? ""),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      vm.setSelectedPriority(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
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
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: IconButton(
              icon: Icon(actionIcon, color: primary, size: 20),
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



  /// Box Field
  Widget _buildBoxField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  /// Date Field
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Due Date", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: dateController,
          readOnly: true,
          style: const TextStyle(fontSize: 14),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primary,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              dateController.text =
                  DateFormat('dd MMM yyyy').format(pickedDate);
            }
          },
          decoration: InputDecoration(
            hintText: "Select date",
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
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

  Widget _buildDropdownField() {
    return Consumer<QueryViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Query/Category",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),

              child: vm.isLoading
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              )
                  : vm.queryList.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(12),
                child: Text("No categories found"),
              )
                  : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: vm.queryList.any((e) => e.categoryName == vm.selectedQuery)
                      ? vm.selectedQuery
                      : null,                  isExpanded: true,
                  hint: const Text("Select Category"),
                  icon: const Icon(Icons.keyboard_arrow_down),

                  items: vm.queryList.map((item) {
                    return DropdownMenuItem(
                      value: item.categoryName,
                      child: Text(item.categoryName ?? ""),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      vm.setSelectedQuery(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
