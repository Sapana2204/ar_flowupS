import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/customers_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_colors.dart' as AppColors;
import '../../view/createCustomer_screen.dart';
import '../../view/pdfPreview_screen.dart';
import '../../viewmodel/customerReport_viewmodel.dart';
import 'customerReport.dart';

class CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const CustomerCard({super.key, required this.customer});
  bool get hasAmc => customer.isAmc?.toLowerCase() == "yes";

  bool get isAmcExpired {
    if (customer.amcEndDate == null ||
        customer.amcEndDate!.isEmpty) {
      return false;
    }

    final endDate = DateTime.parse(customer.amcEndDate!);
    return endDate.isBefore(DateTime.now());
  }

  bool get isAmcExpiringSoon {
    if (customer.amcEndDate == null ||
        customer.amcEndDate!.isEmpty) {
      return false;
    }
    bool isGenerating = false;
    final endDate = DateTime.parse(customer.amcEndDate!);
    final daysLeft = endDate.difference(DateTime.now()).inDays;

    return daysLeft >= 0 && daysLeft <= 30;
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "active":
        return Colors.green;
      case "inactive":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: hasAmc
              ? (isAmcExpired
              ? Colors.red.shade300
              : Colors.green.shade300)
              : Colors.grey.shade300,
          width: hasAmc ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  customer.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  _tag(
                    customer.status ?? "",
                    getStatusColor(customer.status),
                  ),

                  if (hasAmc) ...[
                    const SizedBox(width: 6),
                    _tag(
                      "AMC",
                      Colors.blue,
                    ),
                  ],
                ],
              )
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 MOBILE + EMAIL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.mobileNo ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Expanded(
                child: Text(
                  customer.email ?? "",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 COMPANY + CUSTOMER ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer.companyName ?? "-",
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                "ID: ${customer.customerId ?? "-"}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          if (hasAmc) ...[
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isAmcExpired
                    ? Colors.red.withOpacity(0.08)
                    : isAmcExpiringSoon
                    ? Colors.orange.withOpacity(0.08)
                    : Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    isAmcExpired
                        ? Icons.warning_amber_rounded
                        : Icons.verified,
                    size: 18,
                    color: isAmcExpired
                        ? Colors.red
                        : isAmcExpiringSoon
                        ? Colors.orange
                        : Colors.green,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      isAmcExpired
                          ? "AMC Expired on ${customer.amcEndDate}"
                          : isAmcExpiringSoon
                          ? "AMC Expiring Soon (${customer.amcEndDate})"
                          : "AMC Valid Till ${customer.amcEndDate}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAmcExpired
                            ? Colors.red
                            : isAmcExpiringSoon
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          /// 🔹 ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Contact Person (optional)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CONTACT PERSON", style: TextStyle(fontSize: 10)),
                  Text(
                    customer.contactPerson ?? "-",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              /// Edit Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _showReportDialog(context, customer.customerId);
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateCustomerScreen(
                            isEdit: true,
                            customerId: customer.customerId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showReportDialog(
      BuildContext context,
      int? customerId,
      ) {
    DateTime toDate = DateTime.now();

    // Default From Date = First day of current month
    DateTime fromDate = DateTime(
      toDate.year,
      toDate.month,
      1,
    );

    final rootContext = context;
    bool isGenerating = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<DateTime?> pickDate({
              required DateTime initialDate,
              required DateTime firstDate,
              required DateTime lastDate,
            }) {
              return showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
            }

            Widget dateField({
              required String title,
              required DateTime date,
              required VoidCallback onTap,
            }) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary.withOpacity(0.05),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(date),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.edit_calendar,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Customer Ticket Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dateField(
                    title: "From Date",
                    date: fromDate,
                    onTap: () async {
                      final picked = await pickDate(
                        initialDate: fromDate,
                        firstDate: DateTime(2020),
                        lastDate: toDate,
                      );

                      if (picked != null) {
                        setState(() {
                          fromDate = picked;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  dateField(
                    title: "To Date",
                    date: toDate,
                    onTap: () async {
                      final picked = await pickDate(
                        initialDate: toDate,
                        firstDate: fromDate,
                        lastDate: DateTime.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          toDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: primary),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: isGenerating
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.download),
                  label: Text(
                    isGenerating
                        ? "Generating..."
                        : "Generate Report",
                  ),
                  onPressed: isGenerating
                      ? null
                      : () async {
                    setState(() {
                      isGenerating = true;
                    });

                    final vm =
                    Provider.of<CustomerReportViewModel>(
                      rootContext,
                      listen: false,
                    );

                    try {
                      await vm.getCustomerReport(
                        customerId: customerId!,
                        fromDate: DateFormat('yyyy-MM-dd')
                            .format(fromDate),
                        toDate: DateFormat('yyyy-MM-dd')
                            .format(toDate),
                      );

                      if (vm.reportModel != null) {
                        final pdfBytes =
                        await PdfService.generateCustomerReportPdf(
                          vm.reportModel!,
                          DateFormat('dd-MM-yyyy')
                              .format(fromDate),
                          DateFormat('dd-MM-yyyy')
                              .format(toDate),
                        );

                        Navigator.pop(context);

                        if (rootContext.mounted) {
                          Navigator.push(
                            rootContext,
                            MaterialPageRoute(
                              builder: (_) => PdfPreviewScreen(
                                pdfBytes: pdfBytes,
                                fileName:
                                "Customer_Report_$customerId.pdf",
                              ),
                            ),
                          );
                        }
                      }
                    } finally {
                      if (context.mounted) {
                        setState(() {
                          isGenerating = false;
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }



  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

}