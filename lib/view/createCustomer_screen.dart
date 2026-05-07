import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/createCustomer_model.dart';
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

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.customerId != null) {
      _loadCustomer();
    }
  }
  Future<void> _loadCustomer() async {
    final vm = Provider.of<CustomersViewModel>(context, listen: false);

    final customer = await vm.getCustomerById(widget.customerId!);

    if (customer == null) return;

    nameController.text = customer.name ?? "";
    contactPersonController.text = customer.contactPerson ?? "";
    mobileController.text = customer.mobileNo ?? "";
    whatsappController.text = customer.waNo ?? "";
    emailController.text = customer.email ?? "";
    panController.text = customer.panNumber ?? "";
    gstController.text = customer.gstNumber ?? "";
    addressController.text = customer.address ?? "";

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
                _labelField("PAN Number", panController),
                _labelField("GST Number", gstController),
                _labelField("Address", addressController, maxLines: 2),
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
              if (isPhoneField) {
                if (v == null || v.isEmpty) return "Mobile number required";
                if (v.length != 10) return "Enter valid 10-digit mobile number";
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
    if (!_formKey.currentState!.validate()) return;

    final vm = Provider.of<CustomersViewModel>(context, listen: false);

    /// ✏️ EDIT MODE
    if (widget.isEdit) {
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
      );

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
    );

    final success = await vm.createCustomer(model);

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
}