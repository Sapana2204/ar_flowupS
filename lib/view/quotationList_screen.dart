import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_new_project/view/quotationDetails_dialog.dart';

import '../model/quotation_model.dart';
import '../res/widgets/quotationCard.dart';
import '../utils/app_colors.dart';
import 'createQuotation_screen.dart';

class QuotationListScreen extends StatefulWidget {
  const QuotationListScreen({super.key});

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<QuotationModel> quotations = [];
  List<QuotationModel> filteredQuotations = [];

  @override
  void initState() {
    super.initState();

    quotations = List.from(dummyQuotations);
    filteredQuotations = quotations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      quotations = List.from(dummyQuotations);
      filteredQuotations = quotations;
      _searchController.clear();
    });
  }

  void _searchQuotation(String value) {
    value = value.toLowerCase();

    setState(() {
      filteredQuotations = quotations.where((q) {
        return q.customerName.toLowerCase().contains(value) ||
            q.firmName.toLowerCase().contains(value) ||
            q.contactNo.contains(value) ||
            q.quotationNo.toLowerCase().contains(value) ||
            q.status.toLowerCase().contains(value);
      }).toList();
    });
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹",
      decimalDigits: 0,
    );

    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Quotation List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateQuotationScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchQuotation,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                    "Search Customer, Firm, Number...",
                    icon: const Icon(Icons.search),
                    suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _searchQuotation("");
                      },
                    )
                        : null,
                  ),
                ),
              ),
            ),

            /// Total Count
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Row(
                children: [

                  Text(
                    "${filteredQuotations.length} Quotations",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(.10),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Static Data",
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: RefreshIndicator(
                color: primary,
                onRefresh: _refresh,
                child: filteredQuotations.isEmpty
                    ? const Center(
                  child: Text(
                    "No Quotations Found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount:
                  filteredQuotations.length,
                  itemBuilder:
                      (context, index) {

                    final quotation =
                    filteredQuotations[index];

                    return Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: QuotationCard(
                        quotation: quotation,

                        onView: () {
                          showDialog(
                            context: context,
                            builder: (_) => QuotationDetailsDialog(
                              quotation: quotation,
                            ),
                          );
                        },

                        onEdit: () {
                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "Edit ${quotation.quotationNo}",
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}