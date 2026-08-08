import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/app_colors.dart';

class CustomerModel {
  final int id;
  final String customerName;
  final String firmName;
  final String contact;
  final String email;
  final String address;

  CustomerModel({
    required this.id,
    required this.customerName,
    required this.firmName,
    required this.contact,
    required this.email,
    required this.address,
  });
}

class CreateQuotationScreen extends StatefulWidget {
  const CreateQuotationScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<CustomerModel> customers = [
    CustomerModel(
      id: 1,
      customerName: "ABC Industries",
      firmName: "ABC Engineering Pvt Ltd",
      contact: "9876543210",
      email: "abc@gmail.com",
      address: "MIDC Ambad, Nashik",
    ),
    CustomerModel(
      id: 2,
      customerName: "SP Traders",
      firmName: "SP Traders",
      contact: "9988776655",
      email: "sp@gmail.com",
      address: "Sinnar, Nashik",
    ),
    CustomerModel(
      id: 3,
      customerName: "Flowups Technologies",
      firmName: "Flowups Technologies Pvt Ltd",
      contact: "9090909090",
      email: "info@flowups.in",
      address: "College Road, Nashik",
    ),
  ];

  CustomerModel? selectedCustomer;

  final List<String> responsiblePersons = [
    "John Doe",
    "Rahul Sharma",
    "Amit Kumar",
    "Priya Singh",
    "Admin",
  ];

  String? selectedResponsiblePerson;

  final TextEditingController customerController = TextEditingController();

  final TextEditingController firmController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController quotationNoController =
      TextEditingController(text: "QT-2026-001");

  final TextEditingController quotationDateController = TextEditingController();

  final TextEditingController dueDateController = TextEditingController();

  final TextEditingController quotedRateController = TextEditingController();

  final TextEditingController gstController = TextEditingController(text: "18");

  final TextEditingController discountController =
      TextEditingController(text: "0");

  final TextEditingController descriptionController = TextEditingController();

  double discountAmount = 0;
  double gstAmount = 0;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();

    quotationDateController.text =
        DateFormat("dd MMM yyyy").format(DateTime.now());

    quotedRateController.addListener(_calculate);
    gstController.addListener(_calculate);
    discountController.addListener(_calculate);
  }

  @override
  void dispose() {
    quotedRateController.dispose();
    gstController.dispose();
    discountController.dispose();

    customerController.dispose();
    firmController.dispose();
    contactController.dispose();
    emailController.dispose();
    addressController.dispose();

    quotationNoController.dispose();
    quotationDateController.dispose();
    dueDateController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _calculate() {
    double rate = double.tryParse(quotedRateController.text) ?? 0;

    double gst = double.tryParse(gstController.text) ?? 0;

    double discount = double.tryParse(discountController.text) ?? 0;

    discountAmount = (rate * discount) / 100;

    double amountAfterDiscount = rate - discountAmount;

    gstAmount = (amountAfterDiscount * gst) / 100;

    totalAmount = amountAfterDiscount + gstAmount;

    setState(() {});
  }

  Future<void> _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      dueDateController.text = DateFormat("dd MMM yyyy").format(picked);
    }
  }

  ///====================== CARD ======================

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }

  ///====================== TEXT FIELD ======================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? prefixIcon,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: primary,
                )
              : null,
          filled: true,
          fillColor: const Color(0xffF8F9FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  ///====================== DROPDOWN ======================

  Widget _buildCustomerDropdown() {
    return DropdownButtonFormField<CustomerModel>(
      value: selectedCustomer,
      decoration: InputDecoration(
        labelText: "Customer Name",
        prefixIcon: const Icon(
          Icons.person,
          color: primary,
        ),
        filled: true,
        fillColor: const Color(0xffF8F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      items: customers.map((customer) {
        return DropdownMenuItem(
          value: customer,
          child: Text(customer.customerName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          _selectCustomer(value);
        }
      },
    );
  }


  ///====================== BUTTON ======================

  void _selectCustomer(CustomerModel customer) {
    setState(() {
      selectedCustomer = customer;

      customerController.text = customer.customerName;

      firmController.text = customer.firmName;

      contactController.text = customer.contact;

      emailController.text = customer.email;

      addressController.text = customer.address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Quotation",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat("dd MMM yyyy").format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quotationNoController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              ///================ CUSTOMER DETAILS =================

              _buildCard(
                title: "Customer Details",
                icon: Icons.person,
                child: Column(
                  children: [
                    _buildCustomerDropdown(),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: firmController,
                      label: "Firm Name",
                      prefixIcon: Icons.business,
                      readOnly: true,
                    ),
                    _buildTextField(
                      controller: contactController,
                      label: "Contact Number",
                      prefixIcon: Icons.call,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                    ),
                    _buildTextField(
                      controller: emailController,
                      label: "Email Address",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    _buildTextField(
                      controller: addressController,
                      label: "Address",
                      prefixIcon: Icons.location_on_outlined,
                      maxLines: 3,
                      readOnly: true,
                    ),
                  ],
                ),
              ),

              ///================ QUOTATION DETAILS =================

              _buildCard(
                title: "Quotation Details",
                icon: Icons.description_outlined,
                child: Column(
                  children: [
                    _buildDropdown(
                      label: "Responsible Person",
                      icon: Icons.person_outline,
                      items: responsiblePersons,
                      value: selectedResponsiblePerson,
                      onChanged: (value) {
                        setState(() {
                          selectedResponsiblePerson = value;
                        });
                      },
                    ),
                    _buildTextField(
                      controller: dueDateController,
                      label: "Due Date",
                      prefixIcon: Icons.event_available,
                      readOnly: true,
                      onTap: _pickDueDate,
                    ),
                  ],
                ),
              ),

              _buildCard(
                title: "Product Details",
                icon: Icons.inventory_2_outlined,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Product",
                        prefixIcon: const Icon(Icons.shopping_bag),
                        filled: true,
                        fillColor: const Color(0xffF8F9FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "CRM Software",
                          child: Text("CRM Software"),
                        ),
                        DropdownMenuItem(
                          value: "Website Development",
                          child: Text("Website Development"),
                        ),
                        DropdownMenuItem(
                          value: "Mobile Application",
                          child: Text("Mobile Application"),
                        ),
                        DropdownMenuItem(
                          value: "AMC Service",
                          child: Text("AMC Service"),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),

              _buildCard(
                title: "Pricing",
                icon: Icons.currency_rupee,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: quotedRateController,
                      label: "Quoted Rate",
                      prefixIcon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: gstController,
                            label: "GST %",
                            prefixIcon: Icons.percent,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: discountController,
                            label: "Discount %",
                            prefixIcon: Icons.discount,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _smallAmountCard(
                            title: "Discount",
                            value: discountAmount,
                            icon: Icons.discount,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallAmountCard(
                            title: "GST",
                            value: gstAmount,
                            icon: Icons.receipt_long,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.payments,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Grand Total",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            "₹ ${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              _buildCard(
                title: "Description",
                icon: Icons.description,
                child: _buildTextField(
                  controller: descriptionController,
                  label: "Enter Description",
                  prefixIcon: Icons.edit_note,
                  maxLines: 3,
                ),
              ),
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
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Quotation Saved Successfully"),
                  ),
                );

                // Later call your API here
                // createQuotation();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: const Text(
                "Create Quotation",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primary),
          filled: true,
          fillColor: const Color(0xffF8F9FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
        ),
        items: items.map((person) {
          return DropdownMenuItem(
            value: person,
            child: Text(person),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _smallAmountCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(.25),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "₹ ${value.toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
