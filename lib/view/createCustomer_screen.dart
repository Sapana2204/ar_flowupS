import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/createCustomer_model.dart';
import '../model/customerProduct_model.dart';
import '../model/updateCustomer_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/customers_viewmodel.dart';

class CreateCustomerScreen extends StatefulWidget {
  final int? customerId; // 👈 ADD
  final bool isEdit;     // 👈 ADD

  const CreateCustomerScreen({
    super.key,
    this.customerId,
    this.isEdit = false,
  });

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final contactPersonController = TextEditingController();
  final mobileController = TextEditingController();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  List<TextEditingController> addOnInputControllers = [];
  List<List<String>> productAddOns = [];

  bool isAmc = false;

  DateTime? amcStartDate;
  DateTime? amcEndDate;

  String? selectedAmcPeriod;

  List<int?> selectedProducts = [];
  List<TextEditingController> serialControllers = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CustomersViewModel>(
        context,
        listen: false,
      ).fetchProducts();
    });

    if (widget.isEdit && widget.customerId != null) {
      _loadCustomer();
    }
  }

  Future<void> _loadCustomer() async {
    final vm = Provider.of<CustomersViewModel>(
      context,
      listen: false,
    );

    final customer = await vm.getCustomerById(
      widget.customerId!,
    );

    if (customer == null) return;

    nameController.text = customer.name ?? "";
    contactPersonController.text =
        customer.contactPerson ?? "";
    mobileController.text = customer.mobileNo ?? "";
    whatsappController.text = customer.waNo ?? "";
    emailController.text = customer.email ?? "";
    panController.text = customer.panNumber ?? "";
    gstController.text = customer.gstNumber ?? "";
    addressController.text = customer.address ?? "";

    isAmc = customer.isAmc == "yes";

    selectedAmcPeriod = switch (
    customer.amcTermPeriod) {
      "3_month" => "3 Months",
      "6_month" => "6 Months",
      "1_year" => "1 Year",
      _ => null,
    };

    if (customer.amcStartDate != null &&
        customer.amcStartDate!.isNotEmpty) {
      amcStartDate = DateTime.tryParse(
        customer.amcStartDate!,
      );
    }

    if (customer.amcEndDate != null &&
        customer.amcEndDate!.isNotEmpty) {
      amcEndDate = DateTime.tryParse(
        customer.amcEndDate!,
      );
    }

    /// Clear old data
    selectedProducts.clear();
    serialControllers.clear();
    addOnInputControllers.clear();
    productAddOns.clear();

    /// Load products
    for (final product
    in customer.customerProducts ?? []) {
      selectedProducts.add(
        int.tryParse(product.productId ?? ""),
      );

      serialControllers.add(
        TextEditingController(
          text: product.serialNumber ?? "",
        ),
      );

      /// Empty controller used for entering new addon
      addOnInputControllers.add(
        TextEditingController(),
      );

      /// Existing addons from API
      productAddOns.add(
        List<String>.from(
          product.addOns ?? [],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CustomersViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Update Customer" : "Add Customer"),
        backgroundColor: primary,
      ),
      backgroundColor: const Color(0xFFF5F6FA),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 BASIC INFO
              const Text("BASIC INFORMATION",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 10),

              _card([
                _labelField("Customer Name", nameController, required: true),
                _labelField("Contact Person", contactPersonController, required: true),
              ]),

              const SizedBox(height: 16),

              /// 🔹 CONTACT INFO
              const Text("CONTACT DETAILS",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 10),

              _card([
                _labelField(
                  "Mobile Number",
                  mobileController,
                  keyboard: TextInputType.phone,
                  required: true,
                ),

                _labelField("WhatsApp Number", whatsappController,
                    keyboard: TextInputType.phone),

                _labelField("Email Address", emailController,
                    keyboard: TextInputType.emailAddress),
              ]),

              const SizedBox(height: 16),

              /// 🔹 OTHER INFO
              const Text("OTHER DETAILS",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 10),

              _card([
                // _labelField("PAN Number", panController),
                _labelField("GST Number", gstController),
                _labelField("Address", addressController, maxLines: 2),
              ]),

              const SizedBox(height: 16),

              const Text(
                "AMC DETAILS",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              _card([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Is AMC",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: isAmc,
                      activeColor: primary,
                      onChanged: (value) {
                        setState(() {
                          isAmc = value;
                        });
                      },
                    ),
                  ],
                ),

                if (isAmc) ...[
                  DropdownButtonFormField<String>(
                    isDense: true,
                    value: selectedAmcPeriod,
                    decoration: InputDecoration(
                      labelText: "AMC Period",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F6FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "3 Months",
                        child: Text("3 Months"),
                      ),
                      DropdownMenuItem(
                        value: "6 Months",
                        child: Text("6 Months"),
                      ),
                      DropdownMenuItem(
                        value: "1 Year",
                        child: Text("1 Year"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAmcPeriod = value;
                      });
                      _calculateAmcEndDate();
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          label: "Start Date",
                          selectedDate: amcStartDate,
                          onTap: () async {
                            final date = await pickDate(context);

                            if (date != null) {
                              setState(() {
                                amcStartDate = date;
                              });

                              _calculateAmcEndDate();
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _readOnlyDateField(
                          label: "End Date",
                          selectedDate: amcEndDate,
                        ),
                      ),
                    ],
                  ),
                ]
              ]),

              const SizedBox(height: 16),

              const Text(
                "PRODUCTS",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              _card([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Products",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Assign products and serial numbers ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 34,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            selectedProducts.add(null);

                            serialControllers.add(
                              TextEditingController(),
                            );

                            addOnInputControllers.add(
                              TextEditingController(),
                            );

                            productAddOns.add([]);
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 16,
                        ),
                        label: const Text(
                          "Add",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),
                ...List.generate(
                  selectedProducts.length,
                      (index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [

                        /// Product Dropdown
                        DropdownButtonFormField<int>(
                          value: selectedProducts[index],
                          isDense: true,
                          decoration: InputDecoration(
                            labelText: "Select Product",
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F6FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: vm.products
                              .where((product) {
                            return !selectedProducts.contains(product.productId) ||
                                product.productId == selectedProducts[index];
                          })
                              .map((product) {
                            return DropdownMenuItem<int>(
                              value: product.productId,
                              child: Text(product.productName ?? ""),
                            );
                          })
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            // Check duplicate product
                            final alreadySelected = selectedProducts.asMap().entries.any(
                                  (entry) =>
                              entry.key != index &&
                                  entry.value == value,
                            );

                            if (alreadySelected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("This product is already added."),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              selectedProducts[index] = value;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        /// Serial No
                        TextFormField(
                          controller: serialControllers[index],
                          decoration: InputDecoration(
                            labelText: "Serial Number",
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F6FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: addOnInputControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Add-On Feature",
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F6FA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () {
                                final addon =
                                addOnInputControllers[index].text.trim();

                                if (addon.isEmpty) return;

                                setState(() {
                                  productAddOns[index].add(addon);
                                  addOnInputControllers[index].clear();
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: productAddOns[index]
                              .map(
                                (addon) => Chip(
                              label: Text(addon),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  productAddOns[index].remove(addon);
                                });
                              },
                            ),
                          )
                              .toList(),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                serialControllers[index].dispose();
                                addOnInputControllers[index].dispose();

                                serialControllers.removeAt(index);
                                addOnInputControllers.removeAt(index);

                                productAddOns.removeAt(index);
                                selectedProducts.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ]),


            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xFFF5F6FA),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Consumer<CustomersViewModel>(
              builder: (context, vm, _) {
                return ElevatedButton.icon(
                  onPressed: vm.isLoading ? null : _submit,
                  icon: const Icon(Icons.save),
                  label: vm.isLoading
                      ? const Text("Saving...")
                      : Text(widget.isEdit ? "Update Customer" : "Save Customer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }



  Widget _readOnlyDateField({
    required String label,
    required DateTime? selectedDate,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        suffixIcon: Icon(
          Icons.calendar_month,
          color: primary,
          size: 20,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      child: Text(
        selectedDate == null
            ? "Auto"
            : "${selectedDate.day.toString().padLeft(2, '0')}/"
            "${selectedDate.month.toString().padLeft(2, '0')}/"
            "${selectedDate.year}",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  void _calculateAmcEndDate() {
    if (amcStartDate == null || selectedAmcPeriod == null) return;

    switch (selectedAmcPeriod) {
      case '3 Months':
        amcEndDate = DateTime(
          amcStartDate!.year,
          amcStartDate!.month + 3,
          amcStartDate!.day,
        );
        break;

      case '6 Months':
        amcEndDate = DateTime(
          amcStartDate!.year,
          amcStartDate!.month + 6,
          amcStartDate!.day,
        );
        break;

      case '1 Year':
        amcEndDate = DateTime(
          amcStartDate!.year + 1,
          amcStartDate!.month,
          amcStartDate!.day,
        );
        break;
    }

    setState(() {});
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          suffixIcon: Icon(
            Icons.calendar_month,
            color: primary,
            size: 20,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        child: Text(
          selectedDate == null
              ? "Select"
              : "${selectedDate.day.toString().padLeft(2, '0')}/"
              "${selectedDate.month.toString().padLeft(2, '0')}/"
              "${selectedDate.year}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }


  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _labelField(
      String label,
      TextEditingController controller, {
        bool required = false,
        int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
      }) {
    final isPhoneField = label.toLowerCase().contains("mobile") ||
        label.toLowerCase().contains("whatsapp");

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,

            /// ✅ Apply formatter ONLY for phone
            inputFormatters: isPhoneField
                ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
                : null,

            validator: (v) {
              if (required && (v == null || v.isEmpty)) {
                return "$label required";
              }

              /// 📱 Mobile validation
              final isMobileField =
              label.toLowerCase().contains("mobile");

              if (isMobileField) {
                if (v == null || v.isEmpty) {
                  return "Mobile number required";
                }

                if (v.length != 10) {
                  return "Enter valid 10-digit mobile number";
                }
              }

              if (label.toLowerCase().contains("whatsapp") &&
                  v != null &&
                  v.isNotEmpty &&
                  v.length != 10) {
                return "Enter valid WhatsApp number";
              }

              /// 📧 Email validation
              if (label.toLowerCase().contains("email") && v!.isNotEmpty) {
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v)) return "Enter valid email";
              }

              return null;
            },

            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Enter $label",
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF5F6FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// SUBMIT
  Future<void> _submit() async {

    print("===== SUBMIT CLICKED =====");
    print("selectedProducts : $selectedProducts");
    print("productAddOns : $productAddOns");
    final isValid = _formKey.currentState!.validate();

    print("FORM VALID = $isValid");

    if (!isValid) return;

    final vm = Provider.of<CustomersViewModel>(context, listen: false);

// Check duplicate products
    final selectedIds = selectedProducts.whereType<int>().toList();

    if (selectedIds.length != selectedIds.toSet().length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Duplicate products are not allowed for the same customer.",
          ),
        ),
      );
      return;
    }

    /// ✏️ EDIT MODE
    if (widget.isEdit) {

      final customerProducts = <Map<String, dynamic>>[];
      final productIds = <String>[];

      for (int i = 0; i < selectedProducts.length; i++) {

        final product = vm.products.firstWhere(
              (e) => e.productId == selectedProducts[i],
        );
        customerProducts.add({
          "product_id": product.productId.toString(),
          "product_name": product.productName,
          "serial_number": serialControllers[i].text,
          "add_ons": productAddOns[i],
        });

        productIds.add(product.productId.toString());
      }

      final model = UpdateCustomer(
        customerId: widget.customerId,
        name: nameController.text,
        contactPerson: contactPersonController.text,
        mobileNo: mobileController.text,
        waNo: whatsappController.text,
        email: emailController.text,
        panNumber: panController.text,
        gstNumber: gstController.text,
        address: addressController.text,

        isAmc: isAmc ? "yes" : "no",
        amcTermPeriod: getAmcApiValue(),

        amcStartDate: amcStartDate == null
            ? null
            : amcStartDate!.toIso8601String().split('T').first,

        amcEndDate: amcEndDate == null
            ? null
            : amcEndDate!.toIso8601String().split('T').first,

        status: "active",

        customerProducts: customerProducts,
        productIds: productIds,
        products: customerProducts,
      );

      print("========== UPDATE CUSTOMER REQUEST ==========");
      print(
        const JsonEncoder.withIndent('  ').convert(model.toJson()),
      );
      print("============================================");

      final success = await vm.updateCustomer(model);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Customer Updated")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Update failed")),
        );
      }

      return;
    }

    final productList = <Map<String, dynamic>>[];
    print("STEP 1");

    for (int i = 0; i < selectedProducts.length; i++) {
      print("STEP 2 : ${selectedProducts[i]}");

      final product = vm.products.firstWhere(
            (e) => e.productId == selectedProducts[i],
      );

      print("STEP 3 : ${product.productName}");

      productList.add({
        "product_id": product.productId.toString(),
        "product_name": product.productName,
        "serial_number": serialControllers[i].text,
        "add_ons": productAddOns[i],
      });
    }

    print("STEP 4");

    /// ➕ CREATE MODE
    final model = CreateCustomer(
      name: nameController.text,
      contactPerson: contactPersonController.text,
      mobileNo: mobileController.text,
      waNo: whatsappController.text,
      email: emailController.text,
      panNumber: panController.text,
      gstNo: gstController.text,
      address: addressController.text,

      isAmc: isAmc ? "yes" : "no",
      amcTermPeriod: getAmcApiValue(),

      amcStartDate: amcStartDate == null
          ? null
          : amcStartDate!.toIso8601String().split('T').first,

      amcEndDate: amcEndDate == null
          ? null
          : amcEndDate!.toIso8601String().split('T').first,

      customerProducts: productList,
    );
    print("REQUEST JSON");
    print(
      const JsonEncoder.withIndent('  ')
          .convert(model.toJson()),
    );

    print("STEP 5");

    final success = await vm.createCustomer(model);

    print("STEP 6");
    print("API RESULT = $success");
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Customer Created")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed")),
      );
    }
  }

  String? getAmcApiValue() {
    switch (selectedAmcPeriod) {
      case "3 Months":
        return "3_month";
      case "6 Months":
        return "6_month";
      case "1 Year":
        return "1_year";
      default:
        return null;
    }
  }
}