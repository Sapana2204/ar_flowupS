import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import '../utils/routes/app_colors.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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
              children: [
                Expanded(
                  child: _buildTextFieldWithController(
                    "Client Name",
                    "Enter name",
                    Icons.person,
                    nameController,
                  ),
                ),
                const SizedBox(width: 5),

                /// 📜 HISTORY BUTTON
                GestureDetector(
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.history, color: primary),
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
              Icons.contacts,
              pickContact,
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
                  child: _buildBoxField("Query/Category", "Technical Support"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// PRIORITY
            const Text("Priority Level"),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: ["Low", "Medium", "High"].map((e) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          priority = e;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: priority == e ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: priority == e ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

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

  // Future<void> pickContact() async {
  //   bool permission = await FlutterContacts.requestPermission();
  //
  //   debugPrint("CONTACT PERMISSION STATUS: $permission");
  //
  //   if (!permission) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Permission denied")),
  //     );
  //     return;
  //   }
  //
  //   List<Contact> contacts = await FlutterContacts.getContacts(
  //     withProperties: true,
  //   );
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.7,
  //         padding: const EdgeInsets.all(10),
  //         child: ListView.builder(
  //           itemCount: contacts.length,
  //           itemBuilder: (context, index) {
  //             final contact = contacts[index];
  //
  //             return ListTile(
  //               title: Text(contact.displayName),
  //               subtitle: contact.phones.isNotEmpty
  //                   ? Text(contact.phones.first.number)
  //                   : const Text("No number"),
  //               onTap: () {
  //                 setState(() {
  //                   nameController.text = contact.displayName;
  //                   phoneController.text =
  //                   contact.phones.isNotEmpty
  //                       ? contact.phones.first.number
  //                       : "";
  //                 });
  //
  //                 Navigator.pop(context);
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

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
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
      VoidCallback onActionTap,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: IconButton(
              icon: Icon(actionIcon, color: primary),
              onPressed: onActionTap,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  /// Reusable Text Field
  Widget _buildTextField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
        const Text("Due Date"),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "mm/dd/yyyy",
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}