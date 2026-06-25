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

  Widget _coloredField(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w700,
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top row -> Customer + Days Left
          Row(
            children: [
              Expanded(
                child: Text(
                  item.customerName ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${item.daysLeft ?? 0} Days",
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// Product Name
          Text(
            item.productName ?? "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          /// Serial + Expiry
          Row(
            children: [
              Expanded(
                child: _coloredField(
                  "Serial No",
                  item.serialNumber ?? "-",
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _coloredField(
                  "Expiry Date",
                  item.expiryDate ?? "-",
                  statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Call + Alert Buttons
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
                    side: const BorderSide(color: primary, width: 1),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Consumer<ProductExpiryViewModel>(
                builder: (context, vm, child) {
                  return SizedBox(
                    height: 30,
                    child: ElevatedButton.icon(
                      onPressed: vm.alertLoading
                          ? null
                          : () async {
                        try {
                          final success = await context
                              .read<ProductExpiryViewModel>()
                              .sendProductExpiryAlert(
                            product: item,
                            customerId:
                            item.customerId?.toString() ?? "",
                          );

                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Product expiry reminder sent successfully.",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString().replaceAll(
                                  "Exception: ",
                                  "",
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: vm.alertLoading
                          ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(
                        Icons.notifications_outlined,
                        size: 14,
                      ),
                      label: Text(
                        vm.alertLoading ? "Sending..." : "Alert",
                        style: const TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F766E),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
                          await context.read<ProductExpiryViewModel>().fetchProductExpiryReport(
                            expiryStatus: selectedStatus == "All"
                                ? ""
                                : selectedStatus.toLowerCase().replaceAll(" ", "_"),
                            fromDate: fromDate == null
                                ? ""
                                : fromDate!.toIso8601String().split('T')[0],
                            toDate: toDate == null
                                ? ""
                                : toDate!.toIso8601String().split('T')[0],
                            expiringDays: int.tryParse(expiringDaysController.text) ?? 30,
                            searchText: searchController.text.trim(),
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Apply"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          searchController.clear();
                          expiringDaysController.text = "30";

                          sheetSetState(() {
                            selectedStatus = "all";
                            fromDate = null;
                            toDate = null;
                          });

                          await context.read<ProductExpiryViewModel>().fetchProductExpiryReport(
                            expiryStatus: "",
                            fromDate: "",
                            toDate: "",
                            expiringDays: 30,
                            searchText: "",
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
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