import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import '../model/productExpiryReport_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/productExpiry_viewmodel.dart';

class ProductExpiryReportScreen extends StatefulWidget {
  const ProductExpiryReportScreen({super.key});

  @override
  State<ProductExpiryReportScreen> createState() =>
      _ProductExpiryReportScreenState();
}

class _ProductExpiryReportScreenState
    extends State<ProductExpiryReportScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController expiringDaysController =
  TextEditingController(text: "30");

  String selectedStatus = "All";

  DateTime? fromDate;
  DateTime? toDate;

  final List<Map<String, dynamic>> products = [
    {
      "expiryDate": "30 Jun 2026",
      "daysLeft": "11 Days",
      "status": "Expiring Soon",
      "customer": "Sapana Padmane",
      "product": "Customization Module",
      "serialNo": "342",
      "company": "AR Infotech",
      "contact": "9689662853",
    }
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProductExpiryViewModel>()
          .fetchProductExpiryReport();
    });
  }

  Future<void> pickDate(
      bool isFrom,
      StateSetter sheetSetState,
      ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary, // header & selected date
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

    if (picked != null) {
      sheetSetState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Widget buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Expired":
        return Colors.red;
      case "Valid":
        return Colors.green;
      case "Expiring Soon":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget buildProductCard(Map<String, dynamic> item) {
    final statusColor = getStatusColor(item["status"]);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item["customer"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item["status"],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 18),

            /// 2 COLUMN DATA
            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Expiry",
                    item["expiryDate"],
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Days",
                    item["daysLeft"],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Product",
                    item["product"],
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Serial",
                    item["serialNo"],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Company",
                    item["company"],
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Contact",
                    item["contact"],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 28,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 14,
                  ),
                  label: const Text(
                    "Alert",
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0F766E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductExpiryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),
      appBar: AppBar(
        title: const Text("Product Expiry Report"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          /// SUMMARY FIXED
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                buildSummaryCard(
                  title: "Total Products",
                  value: "${vm.summary?.total ?? 0}",
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
                buildSummaryCard(
                  title: "Expired",
                  value: "${vm.summary?.expired ?? 0}",
                  icon: Icons.warning_amber,
                  color: Colors.red,
                ),
                buildSummaryCard(
                  title: "Expiring Soon",
                  value: "${vm.summary?.expiringSoon ?? 0}",
                  icon: Icons.schedule,
                  color: Colors.orange,
                ),
                buildSummaryCard(
                  title: "Valid",
                  value: "${vm.summary?.valid ?? 0}",
                  icon: Icons.verified,
                  color: Colors.green,
                ),
              ],
            ),
          ),

          /// PRODUCT LIST SCROLLABLE
          Expanded(
            child: vm.loading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : vm.products.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Data Available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "No product expiry records found",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vm.products.length,
              itemBuilder: (context, index) {
                return buildProductCardFromApi(
                  vm.products[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildProductCardFromApi(ProductExpData item) {
    final status = item.expiryStatus ?? "";

    final statusColor = status == "expired"
        ? Colors.red
        : status == "valid"
        ? Colors.green
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(
                    Icons.person_outline,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.customerName ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        item.companyName ?? "",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status.replaceAll("_", " ").toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// DETAILS
            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Expiry Date",
                    item.expiryDate ?? "-",
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Days Left",
                    "${item.daysLeft ?? 0} Days",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Product",
                    item.productName ?? "-",
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Serial No",
                    item.serialNumber ?? "-",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _compactInfo(
                    "Contact",
                    item.mobileNo ?? "-",
                  ),
                ),
                Expanded(
                  child: _compactInfo(
                    "Email",
                    item.email ?? "-",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 30,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await makeCall(item.mobileNo ?? "");
                    },
                    icon: const Icon(
                      Icons.call,
                      size: 14,
                      color: primary,
                    ),
                    label: const Text(
                      "Call",
                      style: TextStyle(
                        fontSize: 11,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: const BorderSide(
                        color: primary,
                        width: 1,
                      ),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  height: 30,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 14,
                    ),
                    label: const Text(
                      "Alert",
                      style: TextStyle(fontSize: 11),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0F766E),
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> makeCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    builder: (context) {
    return StatefulBuilder(
    builder: (context, sheetSetState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Serial No",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),
                    DropdownMenuItem(
                      value: "Expired",
                      child: Text("Expired"),
                    ),
                    DropdownMenuItem(
                      value: "Expiring Soon",
                      child: Text("Expiring Soon"),
                    ),
                    DropdownMenuItem(
                      value: "Valid",
                      child: Text("Valid"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => pickDate(true, sheetSetState),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "From Expiry",
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            fromDate == null
                                ? "Select Date"
                                : formatDate(fromDate),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: InkWell(
                        onTap: () => pickDate(false, sheetSetState),                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "To Expiry",
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            toDate == null
                                ? "Select Date"
                                : formatDate(toDate),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: expiringDaysController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Expiring Days",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await context
                              .read<ProductExpiryViewModel>()
                              .fetchProductExpiryReport(
                            expiryStatus:
                            selectedStatus.toLowerCase().replaceAll(" ", "_"),
                            fromDate: fromDate == null
                                ? ""
                                : fromDate!.toIso8601String().split('T')[0],
                            toDate: toDate == null
                                ? ""
                                : toDate!.toIso8601String().split('T')[0],
                            expiringDays:
                            int.tryParse(expiringDaysController.text) ?? 30,
                            searchText: searchController.text,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text("Apply"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          searchController.clear();
                          expiringDaysController.text = "30";

                          setState(() {
                            selectedStatus = "All";
                            fromDate = null;
                            toDate = null;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text("Reset"),
                      ),
                    ),
                  ],
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
}