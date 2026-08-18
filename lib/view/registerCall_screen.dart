import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../model/createTicket_model.dart';
import '../model/createWorkLog_model.dart';
import '../model/customerContact_model.dart';
import '../model/customerProduct.dart';
import '../model/customers_model.dart';
import '../model/updateTicket_model.dart';
import '../model/updateWorkLog_model.dart';
import '../utils/app_colors.dart';
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
import 'callDetails_screen.dart';


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

class _RegisterCallScreenState extends State<RegisterCallScreen>
    with WidgetsBindingObserver {
  String priority = "Medium";
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();
  final _formKey = GlobalKey<FormState>();
  String? selectedAddOn;
  CustomerData? selectedCustomer;
  CustomerProduct? selectedProduct;
  bool isLoadingProducts = false;
  List<String> selectedAddOns = [];
  List<CustomerContact> customerContacts = [];
  CustomerContact? selectedContact;
  bool showNewContactCard = false;
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
  final designationController = TextEditingController();
  final departmentController = TextEditingController();
  int? _activeWorkLogId;
  DateTime? _callStartTime;
  bool visitRequired = false;
  bool showReasonField = false;
  String _initialDueDate = "";
  bool _callDetailsOpened = false;
  String? _initialAssignee;
  String? _initialStatus;
  bool addNewContact = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
      if (widget.mode == RegisterCallMode.edit && widget.ticketId != null) {
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
        expectedTimeController.text = data.expectedMinutes ?? "";
        phoneController.text = data.contactNo ?? "";
        contactPersonController.text = data.contactPerson ?? "";
        descriptionController.text = removeHtmlTags(data.description ?? "");
        reasonController.text = data.reason ?? "";
        if (data.dueDate != null && data.dueDate!.isNotEmpty) {
          try {
            final parsed = DateTime.parse(data.dueDate!);
            final formattedDate = DateFormat('dd MMM yyyy').format(parsed);
            dateController.text = formattedDate;

            // ✅ store original due date for comparison
            _initialDueDate = formattedDate;
            showReasonField = false;
          } catch (_) {
            dateController.text = data.dueDate!;
            _initialDueDate = data.dueDate!;
            showReasonField = false;
          }
        }

        /// ✅ START DATE PREFILL
        if (data.startDate != null && data.startDate!.isNotEmpty) {
          try {
            final parsed = DateTime.parse(data.startDate!);
            startDateController.text = DateFormat('dd MMM yyyy').format(parsed);
          } catch (_) {
            startDateController.text = data.startDate!;
          }
        }

        /// ✅ DROPDOWNS (AFTER DATA READY)
        queryVm.setSelectedQueryById(data.queryType);
        queryVm.setSelectedPriorityById(data.ticketPriority);
        queryVm.setSelectedAdminById(data.assignee);
        queryVm.setSelectedStatusById(data.ticketStatus);
        _initialAssignee = queryVm.selectedAdmin;
        _initialStatus = queryVm.selectedStatus;

        /// ✅ 🔥 VERY IMPORTANT: SET CLIENT
        if (data.clientId != null) {
          final clientMatch = queryVm.clientList
              .where(
                (c) => c.customerId.toString() == data.clientId.toString(),
              )
              .toList();

          if (clientMatch.isNotEmpty) {
            final customerVm = Provider.of<CustomersViewModel>(
              context,
              listen: false,
            );

            final customer = await customerVm.getCustomerById(
              clientMatch.first.customerId!,
            );

            selectedCustomer = customer;
            customerContacts = customer?.customerContacts ?? [];
            _checkContactNumber(data.contactNo ?? "");
            visitRequired = (data.visitRequired ?? "n") == "y";

            print("API visitRequired = ${data.visitRequired}");
            print("Checkbox value = $visitRequired");
            if (customer != null && data.productId != null) {
              try {
                selectedProduct = customer.customerProducts?.firstWhere(
                  (p) =>
                      p.serialNumber?.toString() ==
                      data.productSerialNumber?.toString(),
                );

                selectedAddOns.clear();
                if (data.productAddOns != null &&
                    data.productAddOns!.isNotEmpty) {
                  try {
                    String addOnString = data.productAddOns!.trim();

                    addOnString =
                        addOnString.replaceAll('[', '').replaceAll(']', '');

                    if (addOnString.isNotEmpty) {
                      selectedAddOns =
                          addOnString.split(',').map((e) => e.trim()).toList();

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
          _checkContactNumber(phoneController.text);
        }
      }

      setState(() {});
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed &&
        _activeWorkLogId != null &&
        !_callDetailsOpened &&
        mounted) {

      _callDetailsOpened = true;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallDetailsScreen(
            workLogId: _activeWorkLogId!,
            ticketId: widget.ticketId!,
          ),
        ),
      ).then((_) {
        // Reset after returning from CallDetailsScreen
        _activeWorkLogId = null;
        _callDetailsOpened = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          widget.mode == RegisterCallMode.edit
              ? "Update Ticket"
              : "Register Ticket",
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
                      ? ticketData.first.ticketNo // ✅ use correct field name
                      : null;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CLIENT INFORMATION",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),

                      /// ✅ SHOW ONLY IN EDIT MODE + WHEN DATA AVAILABLE
                      if (widget.mode == RegisterCallMode.edit &&
                          ticketNo != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                            "clientId": vm.selectedClient?.customerId,
                            "createdDate": vm.selectedClient?.createdDate,
                            "mode": widget.mode,
                            "ticketId": widget.ticketId,
                            "showVisitTab": visitRequired,
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildProductDropdown(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildVisitRequiredField(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextFieldWithAction(
                      "Client Contact No",
                      "+91",
                      Icons.phone,
                      phoneController,
                      Icons.history,
                      getRecentCalls,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        _checkContactNumber(value);
                      },
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
                  if (widget.mode == RegisterCallMode.edit)
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

              Column(
                children: [
                  if (showNewContactCard) _buildNewContactCard(),

                  if (!showNewContactCard)
                    _buildContactDropdown()
                  else
                    _buildTextField(
                      "Contact Person",
                      "Enter contact person name",
                      contactPersonController,
                    ),
                ],
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

              if (widget.mode == RegisterCallMode.edit && showReasonField) ...[
                const SizedBox(height: 12),
                _buildTextField(
                  "Reason",
                  "Enter reason",
                  reasonController,
                  validator: (value) {
                    if (showReasonField &&
                        (value == null || value.trim().isEmpty)) {
                      return "Reason is required";
                    }
                    return null;
                  },
                ),
              ],

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
                        value:
                            vm.adminList.any((e) => e.name == vm.selectedAdmin)
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
                            _updateReasonVisibility(vm);
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
              const Text("Issue Description"),
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
                                  ? "Update Ticket"
                                  : "Register Ticket",
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Phone number is missing"),
          ),
        );
      }
      return;
    }

    final permission = await Permission.phone.request();

    if (!permission.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Phone permission denied"),
          ),
        );
      }
      return;
    }

    try {
      final vm = Provider.of<TicketsViewModel>(
        context,
        listen: false,
      );

      _callStartTime = DateTime.now();

      final createModel = CreateWorkLogModel(
        ticketId: widget.ticketId!,
        workStartAt: DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(_callStartTime!),
        spentMinutes: 0,
        workDetails: "Call Started",
        workStatus: "working",
      );

      final workLogId = await vm.createWorkLogAndReturnId(createModel);

      if (workLogId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                vm.workLogErrorMessage.isNotEmpty
                    ? vm.workLogErrorMessage
                    : "Unable to start work log",
              ),
            ),
          );
        }
        return;
      }

      // Save work log id
      _activeWorkLogId = workLogId;

      // Reset flag before every call
      _callDetailsOpened = false;

      // Open phone dialer
      await FlutterPhoneDirectCaller.callNumber(phone);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst("Exception: ", ""),
            ),
          ),
        );
      }
    }
  }

  Widget _buildContactDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Contact Person"),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CustomerContact>(
              isExpanded: true,
              value: selectedContact,
              hint: const Text("Select Contact Person"),
              items: customerContacts.map((contact) {
                return DropdownMenuItem(
                  value: contact,
                  child: Text(contact.name ?? ""),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedContact = value;

                  contactPersonController.text =
                      value?.name ?? "";

                  emailController.text =
                      value?.email ?? "";

                  phoneController.text =
                      value?.mobileNo ?? "";
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRegisterCallPressed() async {
    final vm = Provider.of<TicketsViewModel>(context, listen: false);

    if (vm.isCreating || vm.isUpdating) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final ticketVm =
        Provider.of<TicketsViewModel>(context, listen: false); // ✅ ADD
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
      final parsedDate = DateFormat("dd MMM yyyy").parse(dateController.text);
      dueDate = DateFormat("yyyy-MM-dd").format(parsedDate);
    }

    String startDate = "";
    if (startDateController.text.isNotEmpty) {
      final parsedStart =
          DateFormat("dd MMM yyyy").parse(startDateController.text);
      startDate = DateFormat("yyyy-MM-dd").format(parsedStart);
    }

    /// ✅ EDIT MODE → UPDATE API
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
        expectedMinutes: expectedTimeController.text.trim().isEmpty
            ? "0"
            : expectedTimeController.text.trim(),
        visitRequired: visitRequired ? "y" : "n",
      );

      print("📤 UPDATE REQUEST: ${ticket.toJson()}");

      final success = await vm.updateTicket(ticket);

      if (success) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Call Updated Successfully"),
          ),
        );

        Navigator.pop(context, true); // ✅ pop first

        // refresh dashboard after pop
        Future.microtask(() {
          Provider.of<DashboardViewModel>(
            context,
            listen: false,
          ).getDashboardData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.updateMessage)),
        );
      }

      return; // 👈 IMPORTANT (stop here)
    }

    /// ✅ CREATE MODE
    final ticket = CreateTicket(
      clientId: queryVm.selectedClient?.customerId,
      contactNo: phoneController.text,
      saveContact: showNewContactCard,

      contactDetails: showNewContactCard
          ? CustomerContact(
        name: contactPersonController.text.trim(),
        mobileNo: phoneController.text.trim(),
        email: emailController.text.trim(),
        designation: designationController.text.trim(),
        department: departmentController.text.trim(),
      )
          : null,
      description: "<p>${descriptionController.text}</p>",
      queryType: queryVm.getSelectedQueryId(),
      ticketStatus: "205",
      ticketPriority: queryVm.getSelectedPriorityId(),
      assignee: queryVm.getSelectedAdminId(),
      startDate: startDate.isNotEmpty
          ? startDate
          : DateFormat("yyyy-MM-dd").format(DateTime.now()),
      dueDate: dueDate,
      status: "active",
      contactPerson: contactPersonController.text,
      productId: selectedProduct?.productId,
      productName: selectedProduct?.productName,
      productSerialNumber: selectedProduct?.serialNumber,
      productAddOns: jsonEncode(selectedAddOns),
      expectedMinutes: expectedTimeController.text.trim().isEmpty
          ? "0"
          : expectedTimeController.text.trim(),
      visitRequired: visitRequired ? "y" : "n",
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

                _checkContactNumber(phoneController.text);

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
              value: addOns.contains(selectedAddOn) ? selectedAddOn : null,
              hint: Text(
                addOns.isEmpty ? "No Add-ons Available" : "Select Add-on",
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
                        selectedAddOns = value == null ? [] : [value];
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
                      _updateReasonVisibility(vm);
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
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
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
        nameController.text = contact.fullName ?? "";

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
            _checkContactNumber(phoneController.text);
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

  Widget _buildNewContactCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Icon(Icons.person_add_alt_1, color: primary),
              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "New contact for this customer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Checkbox(
                value: addNewContact,
                onChanged: (value) {
                  setState(() {
                    addNewContact = value ?? false;
                  });
                },
              ),

              const Text("Add"),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "No contact found for ${phoneController.text}. It will be saved after ticket creation.",
            style: const TextStyle(color: Colors.grey),
          ),

          /// Show form only after checking
          if (addNewContact) ...[
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Contact Name *",
                    "Contact name",
                    contactPersonController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    "Mobile",
                    "Mobile",
                    phoneController,
                    enabled: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Designation",
                    "Optional",
                    designationController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    "Email",
                    "Optional",
                    emailController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildTextField(
              "Department",
              "Optional",
              departmentController,
            ),
          ],
        ],
      ),
    );
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
                        cursorColor: primary,
                        decoration: InputDecoration(
                          hintText: "Search client...",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: primary,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: primary,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          final query = value.toLowerCase().trim();

                          setState(() {
                            clients = vm.clientList.where((c) {
                              final name = (c.name ?? "").toLowerCase();
                              final mobile = (c.mobileNo ?? "").toLowerCase();

                              final serialMatches =
                              (c.customerProducts ?? []).any((p) {
                                final serialNumber =
                                (p.serialNumber ?? "").toLowerCase();

                                return serialNumber.contains(query);
                              });

                              return name.contains(query) ||
                                  mobile.contains(query) ||
                                  serialMatches;
                            }).toList();
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      customerContacts = customer?.customerContacts ?? [];

                                      _checkContactNumber(phoneController.text);
                                      isLoadingProducts = false;
                                    });

                                    /// ✅ FIX: force UI update
                                    this.setState(() {
                                      nameController.text = client.name ?? "";
                                      phoneController.text =
                                          client.mobileNo ?? "";
                                      _checkContactNumber(phoneController.text);
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

  void _checkContactNumber(String mobile) {
    final number = mobile.replaceAll(RegExp(r'\D'), '');

    final match = customerContacts.where((e) {
      final contactNo = (e.mobileNo ?? '').replaceAll(RegExp(r'\D'), '');
      return contactNo == number;
    }).toList();

    setState(() {
      if (match.isNotEmpty) {
        selectedContact = match.first;

        contactPersonController.text = match.first.name ?? "";
        emailController.text = match.first.email ?? "";

        showNewContactCard = false;
        addNewContact = false; // ✅ hide checkbox form
      } else {
        selectedContact = null;

        contactPersonController.clear();
        emailController.clear();
        designationController.clear();
        departmentController.clear();

        showNewContactCard = true; // show "New Contact" card
        addNewContact = false;     // ✅ checkbox remains unchecked initially
      }
    });
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
    expectedTimeController.clear();

    selectedCustomer = null;
    selectedProduct = null;
    selectedAddOns.clear();
    selectedAddOn = null;
  }

  Widget _buildVisitRequiredField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Visit Required"),
        const SizedBox(height: 6),
        SizedBox(
          height: 48,
          child: InkWell(
            onTap: () {
              setState(() {
                visitRequired = !visitRequired;
              });
            },
            child: Row(
              children: [
                Checkbox(
                  value: visitRequired,
                  activeColor: primary,
                  onChanged: (value) {
                    setState(() {
                      visitRequired = value ?? false;
                    });
                  },
                ),
                const Text("Yes"),
              ],
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
    VoidCallback onTap, {
    bool enabled = true, // 👈 ADD
    String? Function(String?)? validator, // ✅ ADD THIS
    TextInputType keyboardType = TextInputType.text, // ✅ ADD THIS
     ValueChanged<String>? onChanged, // 👈 ADD

      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: onChanged, // 👈 ADD
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
            DateTime initialDate = DateTime.now();

            if (dateController.text.isNotEmpty) {
              try {
                initialDate =
                    DateFormat('dd MMM yyyy').parse(dateController.text);
              } catch (_) {}
            }

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    useMaterial3: false,
                    colorScheme: const ColorScheme.light(
                      primary: primary,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              final selectedDate =
              DateFormat('dd MMM yyyy').format(pickedDate);

              setState(() {
                dateController.text = selectedDate;

                // ✅ Only in edit mode, show reason if due date changed
                if (widget.mode == RegisterCallMode.edit) {
                  dateController.text = selectedDate;
                  _updateReasonVisibility(
                      Provider.of<QueryViewModel>(context, listen: false));
                }
              });
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
          readOnly: true,
          onTap: () {},
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: "Start date",
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

  void _showCallDetailsDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Call Details"),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Enter call details",
            ),
          ),
          actions: [
            Consumer<TicketsViewModel>(
              builder: (context, vm, child) {
                return ElevatedButton(
                  onPressed: vm.updateWorkLogLoading
                      ? null
                      : () async {
                          if (controller.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Call details required",
                                ),
                              ),
                            );
                            return;
                          }

                          final model = UpdateWorkLogModel(
                            workLogId: _activeWorkLogId!,
                            ticketId: widget.ticketId!,
                            workDetails: controller.text.trim(),
                            workStatus: "completed",
                          );

                          final success = await vm.updateWorkLog(model);

                          print("SUCCESS => $success");

                          if (success) {
                            print("BEFORE POP");

                            _activeWorkLogId = null;

                            if (mounted) {
                              Navigator.of(context).pop();
                              print("AFTER POP");
                            }
                          }
                        },
                  child: const Text(
                    "Submit",
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _updateReasonVisibility(QueryViewModel vm) {
    final dueDateChanged = dateController.text != _initialDueDate;
    final assigneeChanged = vm.selectedAdmin != _initialAssignee;
    final statusChanged = vm.selectedStatus != _initialStatus;

    setState(() {
      showReasonField =
          dueDateChanged || assigneeChanged || statusChanged;

      if (!showReasonField) {
        reasonController.clear();
      }
    });
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
