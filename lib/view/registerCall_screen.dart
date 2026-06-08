import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/createTicket_model.dart';
import '../model/customerProduct.dart';
import '../model/customers_model.dart';
import '../model/updateTicket_model.dart';
import '../utils/app_colors.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';
import '../utils/enums/register_call_mode.dart';
import '../utils/routes/routes_names.dart';
import '../viewModel/dashboard_viewmodel.dart';
import '../viewModel/login_viewmodel.dart';
import '../viewmodel/customers_viewmodel.dart';
import '../viewmodel/query_viewmodel.dart';
import '../viewmodel/tickets_viewmodel.dart';

class RegisterCallScreen extends StatefulWidget {
  final RegisterCallMode mode;
  final int? ticketId;
  final int? clientId;

  const RegisterCallScreen({
    super.key,
    this.mode = RegisterCallMode.create,
    this.ticketId,
    this.clientId,
  });

  @override
  State<RegisterCallScreen> createState() => _RegisterCallScreenState();
}

class _RegisterCallScreenState extends State<RegisterCallScreen> {
  String priority = "Medium";
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();
  final _formKey = GlobalKey<FormState>();
  String? selectedAddOn;
  CustomerData? selectedCustomer;
  CustomerProduct? selectedProduct;
  bool isLoadingProducts = false;
  List<String> selectedAddOns = [];
  TextEditingController expectedTimeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final queryVm = Provider.of<QueryViewModel>(context, listen: false);
      final loginVm = Provider.of<LoginViewModel>(context, listen: false);
      final ticketVm = Provider.of<TicketsViewModel>(context, listen: false);

      /// ✅ CLEAR EVERYTHING FIRST (ONLY CREATE MODE)
      if (widget.mode == RegisterCallMode.create) {
        _clearAllFields();
        queryVm.resetSelections();
      }

      /// ✅ WAIT LOGIN
      while (loginVm.userData == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      /// ✅ LOAD DATA (WAIT ALL)
      await Future.wait([
        if (queryVm.adminList.isEmpty) queryVm.fetchAdmins(),
        if (queryVm.clientList.isEmpty) queryVm.fetchClients(),
        if (queryVm.queryList.isEmpty) queryVm.fetchQueryTypes(),
        if (queryVm.priorityList.isEmpty) queryVm.fetchPriorityLevels(),
        if (queryVm.statusList.isEmpty) queryVm.fetchStatusList(),
      ]);

      /// ✅ EDIT MODE (DO FIRST)
      if (widget.mode == RegisterCallMode.edit &&
          widget.ticketId != null) {

        await ticketVm.fetchTicketById(
          ticketId: widget.ticketId!,
          clientId: widget.clientId,
        );

        final list = ticketVm.ticketDetail?.data;

        if (list == null || list.isEmpty) return;

        final data = list.first;

        print("===== EDIT TICKET DATA =====");
        print(data.toJson());
        print("productAddOns = ${data.productAddOns}");
        print("expectedMinutes = ${data.expectedMinutes}");
        print("productSerialNumber = ${data.productSerialNumber}");
        expectedTimeController.text =
            data.expectedMinutes ?? "";
        /// ✅ TEXT FIELDS
        phoneController.text = data.contactNo ?? "";
        contactPersonController.text = data.contactPerson ?? "";
        descriptionController.text =
            removeHtmlTags(data.description ?? "");
        reasonController.text = data.reason ?? "";

        /// ✅ DATE FORMAT FIX
        if (data.dueDate != null && data.dueDate!.isNotEmpty) {
          try {
            final parsed = DateTime.parse(data.dueDate!);
            dateController.text =
                DateFormat('dd MMM yyyy').format(parsed);
          } catch (_) {
            dateController.text = data.dueDate!;
          }
        }
        /// ✅ START DATE PREFILL
        if (data.startDate != null && data.startDate!.isNotEmpty) {
          try {
            final parsed = DateTime.parse(data.startDate!);
            startDateController.text =
                DateFormat('dd MMM yyyy').format(parsed);
          } catch (_) {
            startDateController.text = data.startDate!;
          }
        }

        /// ✅ DROPDOWNS (AFTER DATA READY)
        queryVm.setSelectedQueryById(data.queryType);
        queryVm.setSelectedPriorityById(data.ticketPriority);
        queryVm.setSelectedAdminById(data.assignee);
        queryVm.setSelectedStatusById(data.ticketStatus);

        /// ✅ 🔥 VERY IMPORTANT: SET CLIENT
        if (data.clientId != null) {
          final clientMatch = queryVm.clientList.where(
                (c) => c.customerId.toString() == data.clientId.toString(),
          ).toList();

          if (clientMatch.isNotEmpty) {
            final customerVm =
            Provider.of<CustomersViewModel>(
              context,
              listen: false,
            );

            final customer =
            await customerVm.getCustomerById(
              clientMatch.first.customerId!,
            );

            selectedCustomer = customer;
            if (customer != null &&
                data.productId != null) {
              try {
                selectedProduct =
                    customer.customerProducts?.firstWhere(
                          (p) =>
                      p.serialNumber?.toString() ==
                          data.productSerialNumber?.toString(),
                    );
                // Restore Add-ons
                selectedAddOns.clear();
                if (data.productAddOns != null &&
                    data.productAddOns!.isNotEmpty) {
                  try {
                    String addOnString = data.productAddOns!.trim();

                    // Remove brackets
                    addOnString =
                        addOnString.replaceAll('[', '').replaceAll(']', '');

                    if (addOnString.isNotEmpty) {
                      selectedAddOns = addOnString
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

                      selectedAddOn = selectedAddOns.first;
                    }
                  } catch (e) {
                    print("Add-on parse error: $e");
                  }
                }
              } catch (_) {}
            }
            print("Available AddOns: ${selectedProduct?.addOns}");
            print("Selected AddOns: $selectedAddOns");
            print("Selected AddOn: $selectedAddOn");
            queryVm.setSelectedClient(clientMatch.first);
            print(ticketVm.ticketDetail?.data?.first.toJson());
            nameController.text = clientMatch.first.name ?? "";
            phoneController.text = clientMatch.first.mobileNo ?? "";
          }
        }
      }

      /// ✅ CREATE MODE ONLY (DON’T OVERRIDE EDIT)
      else {
        _setDefaultAdmin(queryVm, loginVm);
        final client = queryVm.selectedClient;
        if (client != null) {
          nameController.text = client.name ?? "";
          phoneController.text = client.mobileNo ?? "";
        }
      }

      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          widget.mode == RegisterCallMode.edit
              ? "Update Call"
              : "Register Call",
        ),
        backgroundColor: primary,
      ),
     body: Form(
      key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CLIENT INFO
              /// HEADER (Ticket No + Section Title)
              Consumer<TicketsViewModel>(
                builder: (context, ticketVm, _) {
                  final ticketData = ticketVm.ticketDetail?.data;
                  final ticketNo = (ticketData != null && ticketData.isNotEmpty)
                      ? ticketData.first.ticketNo   // ✅ use correct field name
                      : null;
        
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CLIENT INFORMATION",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
        
                      /// ✅ SHOW ONLY IN EDIT MODE + WHEN DATA AVAILABLE
                      if (widget.mode == RegisterCallMode.edit && ticketNo != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Ticket No: $ticketNo",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
        
              Row(
                crossAxisAlignment: CrossAxisAlignment.end, // 👈 important
                children: [
                  Expanded(
                    child: Consumer<QueryViewModel>(
                      builder: (context, vm, child) {
                        return GestureDetector(
                          onTap: widget.mode == RegisterCallMode.edit
                              ? null
                              : () => _openClientBottomSheet(vm),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    vm.selectedClient?.name ?? "Select Client",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: vm.selectedClient == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 58, // 👈 match TextField height
                    child: GestureDetector(
                      onTap: () {
                        final vm =
                            Provider.of<QueryViewModel>(context, listen: false);
        
                        Navigator.pushNamed(
                          context,
                          RouteNames.clientHistoryScreen,
                          arguments: {
                            "clientName": vm.selectedClient?.name ?? "",
                            "phone": phoneController.text,
                            "clientId": vm.selectedClient?.customerId,   // ✅ correct
                            "createdDate": vm.selectedClient?.createdDate, // ✅ correct
                            "mode": widget.mode, // ✅ ADD
                            "ticketId": widget.ticketId, // ✅ ADD

                          },
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

              _buildProductDropdown(),
        
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextFieldWithAction(
                      "Client Contact No",
                      "+1 (555) 000-000",
                      Icons.phone,
                      phoneController,
                      Icons.history,
                      getRecentCalls,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number required";
                        }
                        if (value.length < 10) {
                          return "Enter valid phone number";
                        }
                        return null;
                      },
                      enabled: widget.mode != RegisterCallMode.edit,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: ElevatedButton(
                        onPressed: _makePhoneCall,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 12),

              _buildTextField(
                "Contact Person",
                "Enter contact person name",
                contactPersonController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Contact person required";
                  }
                  return null;
                },
                enabled: widget.mode != RegisterCallMode.edit, // 👈 ADD
              ),
        
              const SizedBox(height: 12),

              /// CALL DETAILS
              const Text(
                "CALL DETAILS",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),


              Consumer<QueryViewModel>(
                builder: (context, vm, child) {
                  final isCustomization =
                      vm.selectedQuery?.toLowerCase() == "customizations";

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdownField(),
                      ),

                      if (isCustomization) ...[
                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildAddOnsField(),
                        ),
                      ],
                    ],
                  );
                },
              ),
        
              const SizedBox(height: 15),
        
              Row(
                children: [
                  if (widget.mode == RegisterCallMode.edit)
                    Expanded(child: _buildStartDateField()),
        
                  if (widget.mode == RegisterCallMode.edit)
                    const SizedBox(width: 12),
        
                  Expanded(child: _buildDateField()),
                ],
              ),
        
              const SizedBox(height: 15),
        
              /// PRIORITY
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPriorityDropdown(),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _buildExpectedTimeField(),
                  ),
                ],
              ),

              const SizedBox(height: 15),
        
              /// ASSIGN TO
              const Text("Assign To"),
              const SizedBox(height: 8),
        
              Consumer<QueryViewModel>(
                builder: (context, vm, child) {
        
                  if (vm.isLoading && vm.adminList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
        
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
        
                        /// ✅ FIX: ensure value exists
                        value: vm.adminList.any((e) => e.name == vm.selectedAdmin)
                            ? vm.selectedAdmin
                            : null,
        
                        hint: const Text("Select User"),

                        items: vm.adminList.map((user) {
                          return DropdownMenuItem<String>(
                            value: user.name,
                            child: Text(
                              "${user.name} (${user.pendingTicketsCount ?? 0} Pending)",
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            vm.setSelectedAdmin(value);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
        

              if (widget.mode == RegisterCallMode.edit) ...[
                const SizedBox(height: 12),
                _buildStatusDropdown(),
              ],

              const SizedBox(height: 15),

              /// DESCRIPTION
              const Text("Description"),
              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description required";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Briefly describe the call outcome or client needs",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Consumer<TicketsViewModel>(
          builder: (context, vm, child) {
            final isLoading = widget.mode == RegisterCallMode.edit
                ? vm.isUpdating
                : vm.isCreating;

            return Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFF5F6FA),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onRegisterCallPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.call),
                      const SizedBox(width: 8),
                      Text(
                        widget.mode == RegisterCallMode.edit
                            ? "Update Call"
                            : "Register Call",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available")),
      );
      return;
    }

    final status = await Permission.phone.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone permission denied")),
      );
      return;
    }

    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  Future<void> _onRegisterCallPressed() async {
    final vm = Provider.of<TicketsViewModel>(context, listen: false);

    if (vm.isCreating || vm.isUpdating) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ticketVm = Provider.of<TicketsViewModel>(context, listen: false); // ✅ ADD
    final queryVm = Provider.of<QueryViewModel>(context, listen: false);
    final existing = ticketVm.ticketDetail?.data?.isNotEmpty == true
        ? ticketVm.ticketDetail!.data!.first
        : null;

    print("BUTTON CLICKED");

    print("Name: ${nameController.text}");
    print("Phone: ${phoneController.text}");
    print("Query: ${queryVm.selectedQuery}");
    print("Priority: ${queryVm.selectedPriority}");
    print("Admin: ${queryVm.selectedAdmin}");
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        queryVm.selectedQuery == null ||
        queryVm.selectedPriority == null ||
        queryVm.selectedAdmin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    /// ✅ FORMAT DATES
    String dueDate = "";
    if (dateController.text.isNotEmpty) {
      final parsedDate =
      DateFormat("dd MMM yyyy").parse(dateController.text);
      dueDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    }

    String startDate = "";
    if (startDateController.text.isNotEmpty) {
      final parsedStart =
      DateFormat("dd MMM yyyy").parse(startDateController.text);
      startDate = DateFormat("yyyy-MM-dd").format(parsedStart);
    }

    /// =========================
    /// ✅ EDIT MODE → UPDATE API
    /// =========================
    if (widget.mode == RegisterCallMode.edit) {
      final ticket = UpdateTicketModel(
        ticketId: widget.ticketId,
        clientId: queryVm.selectedClient?.customerId,
        contactNo: phoneController.text,
        description: "<p>${descriptionController.text}</p>",
        queryType: queryVm.getSelectedQueryId(),
        ticketStatus: queryVm.getSelectedStatusId(),
        ticketPriority: queryVm.getSelectedPriorityId(),
        assignee: queryVm.getSelectedAdminId(),
        startDate: startDate,
        dueDate: dueDate,
        status: "active",
        contactPerson: contactPersonController.text,
        reason: reasonController.text.isEmpty ? null : reasonController.text,
        // whatsappNo: whatsappController.text,
        /// ✅ SAFE VALUES
        createdBy: existing?.createdBy != null
            ? int.tryParse(existing!.createdBy!)
            : null,
        createdDate: existing?.createdDate,
        companyId: existing?.companyId,
        ticketNo: existing?.ticketNo,
        productId: selectedProduct?.productId,
        productName: selectedProduct?.productName,
        productSerialNumber: selectedProduct?.serialNumber,
        productAddOns: jsonEncode(selectedAddOns),
        expectedMinutes: expectedTimeController.text, // 👈 ADD THIS


      );


      /// ✅ PRINT FULL REQUEST
      print("📤 UPDATE REQUEST: ${ticket.toJson()}");


      final success = await vm.updateTicket(ticket);

      if (success) {

        // ✅ Refresh Dashboard API
        await Provider.of<DashboardViewModel>(
          context,
          listen: false,
        ).getDashboardData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Call Updated Successfully"),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.updateMessage)),
        );
      }

      return; // 👈 IMPORTANT (stop here)
    }

    /// =========================
    /// ✅ CREATE MODE
    /// =========================
    final ticket = CreateTicket(
      clientId: queryVm.selectedClient?.customerId,
      contactNo: phoneController.text,
      description: "<p>${descriptionController.text}</p>",
      queryType: queryVm.getSelectedQueryId(),
      ticketStatus: "206",
      ticketPriority: queryVm.getSelectedPriorityId(),
      assignee: queryVm.getSelectedAdminId(),
      startDate: startDate.isNotEmpty
          ? startDate
          : DateFormat("yyyy-MM-dd").format(DateTime.now()),
      dueDate: dueDate,
      status: "active",
      // whatsappNo: whatsappController.text,
      contactPerson: contactPersonController.text,
      productId: selectedProduct?.productId,
      productName: selectedProduct?.productName,
      productSerialNumber: selectedProduct?.serialNumber,
      productAddOns: jsonEncode(selectedAddOns),
      expectedMinutes: expectedTimeController.text,
    );
    /// ✅ PRINT FULL REQUEST
    print("📤 CREATE REQUEST: ${ticket.toJson()}");

    final success = await vm.createTicket(ticket);

    if (success) {

      // ✅ Refresh Dashboard API
      await Provider.of<DashboardViewModel>(
        context,
        listen: false,
      ).getDashboardData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Call Registered Successfully"),
        ),
      );

      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.createMessage)),
      );
    }
  }

  void _setDefaultAdmin(QueryViewModel vm, LoginViewModel loginVm) {
    final loggedInUser = loginVm.userData?.username?.toLowerCase().trim();

    if (loggedInUser == null || vm.adminList.isEmpty) return;

    final matchList = vm.adminList.where(
          (e) => (e.name ?? "").toLowerCase().contains(loggedInUser),
    );

    if (matchList.isNotEmpty) {
      vm.setSelectedAdmin(matchList.first.name ?? "");
    }
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
                  whatsappController.text = call.number ?? "";
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }


  Widget _buildAddOnsField() {
    final addOns = selectedProduct?.addOns ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add-ons",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: addOns.contains(selectedAddOn)
                  ? selectedAddOn
                  : null,
              hint: Text(
                addOns.isEmpty
                    ? "No Add-ons Available"
                    : "Select Add-on",
              ),
              items: addOns.map((addon) {
                return DropdownMenuItem<String>(
                  value: addon,
                  child: Text(addon),
                );
              }).toList(),
              onChanged: addOns.isEmpty
                  ? null
                  : (value) {
                setState(() {
                  selectedAddOn = value;

                  // Keep API format as List<String>
                  selectedAddOns =
                  value == null ? [] : [value];
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Expected Time (Minutes)"),
        const SizedBox(height: 6),
        TextFormField(
          controller: expectedTimeController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: "Enter Minutes",
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

  Widget _buildProductDropdown() {
    final products = selectedCustomer?.customerProducts ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products"),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CustomerProduct>(
              isExpanded: true,
              value: selectedProduct,
              hint: Text(
                selectedCustomer == null
                    ? "Select Client First"
                    : products.isEmpty
                    ? "No Products Available"
                    : "Select Product",
              ),
              items: products.map((product) {
                return DropdownMenuItem<CustomerProduct>(
                  value: product,
                  child: Text(
                    "${product.productName} (${product.serialNumber})",
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  selectedAddOns.clear();
                  selectedAddOn = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Consumer<QueryViewModel>(
      builder: (context, vm, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Status"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,

                  value: vm.statusList.any(
                        (e) => e.categoryName == vm.selectedStatus,
                  )
                      ? vm.selectedStatus
                      : null,

                  hint: const Text("Select Status"),

                  items: vm.statusList.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.categoryName,
                      child: Text(item.categoryName ?? ""),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      vm.setSelectedStatus(value);
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

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        bool enabled = true,
        String? Function(String?)? validator, // 👈 ADD
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField( // ✅ change here
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator, // 👈 ADD
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
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
        if (contact.phoneNumbers != null && contact.phoneNumbers!.length > 1) {
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

  void _openClientBottomSheet(QueryViewModel vm) {
    TextEditingController searchController = TextEditingController();
    List clients = List.from(vm.clientList);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.5, // 👈 fixed height
                child: Column(
                  children: [
                    /// 🔍 SEARCH BAR
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search client...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            clients = vm.clientList
                                .where((c) =>
                                    (c.name ?? "")
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    (c.mobileNo ?? "").contains(value))
                                .toList();
                          });
                        },
                      ),
                    ),

                    /// ➕ CREATE CUSTOMER BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);

                            await Navigator.pushNamed(
                              context,
                              RouteNames.createCustomerScreen,
                            );

                            vm.fetchClients();
                          },
                          child: const Text(
                            "+ Create Client",
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 📋 LIST
                    Expanded(
                      child: clients.isEmpty
                          ? const Center(child: Text("No clients found"))
                          : ListView.builder(
                              itemCount: clients.length,
                              itemBuilder: (context, index) {
                                final client = clients[index];

                                return ListTile(
                                  title: Text(client.name ?? ""),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(client.mobileNo ?? ""),

                                      ...(client.customerProducts ?? []).map(
                                            (p) => Text(
                                          "SN: ${p.serialNumber}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    vm.setSelectedClient(client);

                                    setState(() {
                                      selectedCustomer = null;
                                      selectedProduct = null;
                                      isLoadingProducts = true;
                                    });

                                    final customerVm =
                                    Provider.of<CustomersViewModel>(
                                      context,
                                      listen: false,
                                    );

                                    final customer =
                                        await customerVm.getCustomerById(
                                      client.customerId!,
                                    );

                                    if (!mounted) return;

                                    this.setState(() {
                                      selectedCustomer = customer;
                                      isLoadingProducts = false;
                                    });
                                    /// ✅ FIX: force UI update
                                    this.setState(() {
                                      nameController.text = client.name ?? "";
                                      phoneController.text = client.mobileNo ?? "";
                                    });

                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _clearAllFields() {
    nameController.clear();
    phoneController.clear();
    dateController.clear();
    descriptionController.clear();
    contactPersonController.clear();
    emailController.clear();
    reasonController.clear();
    commentsController.clear();
    productTypeController.clear();
    serialNoController.clear();
    startDateController.clear();
    whatsappController.clear();
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
      VoidCallback onTap, {
        bool enabled = true, // 👈 ADD
        String? Function(String?)? validator, // ✅ ADD THIS
        TextInputType keyboardType = TextInputType.text, // ✅ ADD THIS
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator, // 👈 ADD
          keyboardType: keyboardType, // ✅ ADD
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
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
                  data: Theme.of(context).copyWith(
                    useMaterial3:
                        false, // ✅ VERY IMPORTANT (removes purple default)
                    colorScheme: const ColorScheme.light(
                      primary: primary, // header + selected date
                      onPrimary: Colors.white, // text on header
                      onSurface: Colors.black, // normal text
                    ),
                    dialogBackgroundColor: Colors.white,
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

  Widget _buildStartDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Start Date", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: startDateController,
          readOnly: true, // 👈 prevents keyboard
          onTap: () {},   // 👈 do nothing (no calendar)
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: "Start date",
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
            filled: true,
            fillColor: Colors.white, // 👈 normal look (not disabled)
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
                            value: vm.queryList.any(
                                    (e) => e.categoryName == vm.selectedQuery)
                                ? vm.selectedQuery
                                : null,
                            isExpanded: true,
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

  InputDecoration commonInputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),

      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primary,
          width: 1.2,
        ),
      ),
    );
  }
}
