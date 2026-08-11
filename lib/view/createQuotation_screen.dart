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

class ProductItem {
  String? product;

  final TextEditingController qtyController =
  TextEditingController(text: '1');

  final TextEditingController rateController =
  TextEditingController(text: '0');

  final TextEditingController discountController =
  TextEditingController(text: '0');

  final TextEditingController gstController =
  TextEditingController(text: '18');

  double get rate => double.tryParse(rateController.text) ?? 0;

  double get qty => double.tryParse(qtyController.text) ?? 0;

  double get discountPercent =>
      double.tryParse(discountController.text) ?? 0;

  double get gstPercent => double.tryParse(gstController.text) ?? 0;

  double get subtotal => qty * rate;

  double get discountAmount =>
      subtotal * discountPercent / 100;

  double get taxableAmount =>
      subtotal - discountAmount;

  double get gstAmount =>
      taxableAmount * gstPercent / 100;

  double get total =>
      taxableAmount + gstAmount;

  void dispose() {
    qtyController.dispose();
    rateController.dispose();
    discountController.dispose();
    gstController.dispose();
  }
}

class CreateQuotationScreen extends StatefulWidget {
  const CreateQuotationScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuotationScreen> createState() =>
      _CreateQuotationScreenState();
}

class _CreateQuotationScreenState
    extends State<CreateQuotationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ---------------------------------------------------------------------------
  // DATA
  // ---------------------------------------------------------------------------

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

  final List<String> products = [
    "CRM Software",
    "Website Development",
    "Mobile Application",
    "AMC Service",
    "Tally Customization",
    "Tally Integration",
    "Software Support",
  ];

  CustomerModel? selectedCustomer;

  final List<ProductItem> productItems = [
    ProductItem(),
  ];

  // ---------------------------------------------------------------------------
  // CONTROLLERS
  // ---------------------------------------------------------------------------

  final TextEditingController quotationNoController =
  TextEditingController(text: "QT-2026-001");

  final TextEditingController quotationDateController =
  TextEditingController();

  final TextEditingController validUntilController =
  TextEditingController();

  final TextEditingController notesController =
  TextEditingController();

  final TextEditingController termsController =
  TextEditingController(
    text: "Prices are valid until the date mentioned above.",
  );

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    quotationDateController.text =
        DateFormat("dd MMM yyyy").format(now);

    validUntilController.text =
        DateFormat("dd MMM yyyy")
            .format(now.add(const Duration(days: 13)));

    for (final item in productItems) {
      _attachListeners(item);
    }
  }

  void _attachListeners(ProductItem item) {
    item.qtyController.addListener(_refresh);
    item.rateController.addListener(_refresh);
    item.discountController.addListener(_refresh);
    item.gstController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    quotationNoController.dispose();
    quotationDateController.dispose();
    validUntilController.dispose();
    notesController.dispose();
    termsController.dispose();

    for (final item in productItems) {
      item.dispose();
    }

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // CALCULATIONS
  // ---------------------------------------------------------------------------

  double get subtotal {
    return productItems.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

  double get totalDiscount {
    return productItems.fold(
      0,
          (sum, item) => sum + item.discountAmount,
    );
  }

  double get totalGst {
    return productItems.fold(
      0,
          (sum, item) => sum + item.gstAmount,
    );
  }

  double get grandTotal {
    return subtotal - totalDiscount + totalGst;
  }

  // ---------------------------------------------------------------------------
  // DATE PICKER
  // ---------------------------------------------------------------------------

  Future<void> _pickDate({
    required TextEditingController controller,
    required DateTime initialDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          DateFormat("dd MMM yyyy").format(picked);

      setState(() {});
    }
  }

  // ---------------------------------------------------------------------------
  // CUSTOMER BOTTOM SHEET
  // ---------------------------------------------------------------------------

  Future<void> _selectCustomer() async {
    final CustomerModel? customer =
    await showModalBottomSheet<CustomerModel>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Select Customer / Lead",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ...customers.map(
                      (customer) {
                    final bool selected =
                        selectedCustomer?.id == customer.id;

                    return InkWell(
                      borderRadius:
                      BorderRadius.circular(16),
                      onTap: () =>
                          Navigator.pop(context, customer),
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? primary.withOpacity(.07)
                              : const Color(0xffF7F9FC),
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? primary
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color:
                                primary.withOpacity(.10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.business_outlined,
                                color: primary,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.customerName,
                                    style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    customer.firmName,
                                    style: TextStyle(
                                      color:
                                      Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    customer.contact,
                                    style: TextStyle(
                                      color:
                                      Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (selected)
                              Icon(
                                Icons.check_circle,
                                color: primary,
                              )
                            else
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade400,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (customer != null) {
      setState(() {
        selectedCustomer = customer;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // PRODUCT BOTTOM SHEET
  // ---------------------------------------------------------------------------

  Future<void> _selectProduct(ProductItem item) async {
    final String? selected =
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 18),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Product / Service",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                ...products.map(
                      (product) {
                    return ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(.08),
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: primary,
                        ),
                      ),
                      title: Text(
                        product,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () =>
                          Navigator.pop(context, product),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        item.product = selected;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // ADD PRODUCT
  // ---------------------------------------------------------------------------

  void _addProduct() {
    final item = ProductItem();

    _attachListeners(item);

    setState(() {
      productItems.add(item);
    });
  }

  void _removeProduct(int index) {
    if (productItems.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "At least one product is required.",
          ),
        ),
      );
      return;
    }

    productItems[index].dispose();

    setState(() {
      productItems.removeAt(index);
    });
  }

  // ---------------------------------------------------------------------------
  // SAVE
  // ---------------------------------------------------------------------------

  void _saveQuotation({
    required bool send,
  }) {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a customer or lead.",
          ),
        ),
      );
      return;
    }

    final hasProduct = productItems.any(
          (item) => item.product != null,
    );

    if (!hasProduct) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least one product.",
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          send
              ? "Quotation saved and ready to send."
              : "Quotation saved as draft.",
        ),
      ),
    );

    // TODO:
    // Call your API here.
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: _buildAppBar(),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16,
          ),
          children: [
            _buildCustomerSection(),

            const SizedBox(height: 16),

            _buildQuotationDetailsSection(),

            const SizedBox(height: 16),

            _buildProductsSection(),

            const SizedBox(height: 16),

            _buildAdditionalDetailsSection(),

            const SizedBox(height: 16),

            _buildSummarySection(),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomActions(),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      titleSpacing: 0,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create Quotation",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            quotationNoController.text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),

      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "DRAFT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .5,
            ),
          ),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.white.withOpacity(.12),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CUSTOMER SECTION
  // ---------------------------------------------------------------------------

  Widget _buildCustomerSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            "Customer / Lead",
            Icons.person_outline,
            required: true,
          ),

          const SizedBox(height: 14),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _selectCustomer,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffF8F9FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selectedCustomer != null
                      ? primary.withOpacity(.4)
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(.09),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      selectedCustomer == null
                          ? Icons.person_add_alt_1
                          : Icons.business_outlined,
                      color: primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: selectedCustomer == null
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Customer / Lead",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Choose a customer for this quotation",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCustomer!.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedCustomer!.firmName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          selectedCustomer!.contact,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUOTATION DETAILS
  // ---------------------------------------------------------------------------

  Widget _buildQuotationDetailsSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            "Quotation Details",
            Icons.description_outlined,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _dateField(
                  label: "Quotation Date",
                  controller: quotationDateController,
                  icon: Icons.calendar_today_outlined,
                  onTap: () {
                    _pickDate(
                      controller:
                      quotationDateController,
                      initialDate: DateTime.now(),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _dateField(
                  label: "Valid Until",
                  controller: validUntilController,
                  icon: Icons.event_available_outlined,
                  onTap: () {
                    _pickDate(
                      controller:
                      validUntilController,
                      initialDate: DateTime.now()
                          .add(const Duration(days: 13)),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRODUCTS
  // ---------------------------------------------------------------------------

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionTitle(
                "Products / Services",
                Icons.inventory_2_outlined,
              ),
            ),

            TextButton.icon(
              onPressed: _addProduct,
              icon: const Icon(
                Icons.add,
                size: 18,
              ),
              label: const Text("Add Product"),
              style: TextButton.styleFrom(
                foregroundColor: primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ...List.generate(
          productItems.length,
              (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildProductCard(
                productItems[index],
                index,
              ),
            );
          },
        ),

        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _addProduct,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: primary.withOpacity(.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primary.withOpacity(.25),
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Add Another Product",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(
      ProductItem item,
      int index,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffE7EBF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Product / Service",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),

              IconButton(
                onPressed: () => _removeProduct(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.shade400,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Product selector
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _selectProduct(item),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF8F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.product ??
                          "Select Product / Service",
                      style: TextStyle(
                        color: item.product == null
                            ? Colors.grey.shade500
                            : Colors.grey.shade800,
                        fontWeight:
                        item.product == null
                            ? FontWeight.w400
                            : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Qty + Rate
          Row(
            children: [
              Expanded(
                child: _compactField(
                  controller: item.qtyController,
                  label: "Quantity",
                  prefix: null,
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _compactField(
                  controller: item.rateController,
                  label: "Rate",
                  prefix: "₹",
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Discount + GST
          Row(
            children: [
              Expanded(
                child: _compactField(
                  controller: item.discountController,
                  label: "Discount %",
                  prefix: null,
                  suffix: "%",
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _compactField(
                  controller: item.gstController,
                  label: "GST %",
                  prefix: null,
                  suffix: "%",
                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Amount
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF4F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: primary,
                  size: 19,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  _currency(item.total),
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NOTES + TERMS
  // ---------------------------------------------------------------------------

  Widget _buildAdditionalDetailsSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            "Additional Details",
            Icons.notes_outlined,
          ),

          const SizedBox(height: 14),

          _multilineField(
            controller: notesController,
            label: "Notes",
            hint: "Add notes for the customer...",
            icon: Icons.sticky_note_2_outlined,
          ),

          const SizedBox(height: 12),

          _multilineField(
            controller: termsController,
            label: "Terms & Conditions",
            hint: "Enter quotation terms and conditions...",
            icon: Icons.gavel_outlined,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------------

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffE7EBF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: primary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "Quotation Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _summaryRow(
            "Subtotal",
            subtotal,
          ),

          const SizedBox(height: 10),

          _summaryRow(
            "Discount",
            totalDiscount,
            valueColor: Colors.orange.shade700,
            prefix: "- ",
          ),

          const SizedBox(height: 10),

          _summaryRow(
            "GST",
            totalGst,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              height: 1,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Grand Total",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  _currency(grandTotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------

  Widget _buildBottomActions() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          10,
          14,
          10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _saveQuotation(send: false);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize:
                  const Size(double.infinity, 50),
                  side: BorderSide(
                    color: primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  "Save Draft",
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: () {
                  _saveQuotation(send: true);
                },
                icon: const Icon(
                  Icons.send_outlined,
                  size: 18,
                ),
                label: const Text(
                  "Save & Send",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize:
                  const Size(double.infinity, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMMON WIDGETS
  // ---------------------------------------------------------------------------

  Widget _sectionContainer({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffE8ECF1),
        ),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(
      String title,
      IconData icon, {
        bool required = false,
      }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 18,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),

        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            "*",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffF8F9FC),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: primary,
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 11,
        ),
        prefixText: prefix,
        suffixText: suffix,
        prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        suffixStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
        isDense: true,
        filled: true,
        fillColor: const Color(0xffF8F9FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            bottom: 55,
          ),
          child: Icon(
            icon,
            color: primary,
            size: 19,
          ),
        ),
        filled: true,
        fillColor: const Color(0xffF8F9FC),
        contentPadding: const EdgeInsets.all(13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            color: primary,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
      String title,
      double value, {
        Color? valueColor,
        String prefix = "",
      }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          "$prefix${_currency(value)}",
          style: TextStyle(
            color: valueColor ?? Colors.grey.shade800,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _currency(double value) {
    return "₹ ${value.toStringAsFixed(2)}";
  }
}