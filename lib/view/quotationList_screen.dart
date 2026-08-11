import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/widgets/quotationCard.dart';
import '../utils/app_colors.dart';
import '../viewmodel/quotation_viewmodel.dart';
import 'createQuotation_screen.dart';
import 'quotationDetails_dialog.dart';

class QuotationListScreen extends StatelessWidget {
  const QuotationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotationViewModel()
        ..fetchQuotations(),
      child: const QuotationListBody(),
    );
  }
}

class QuotationListBody extends StatefulWidget {
  const QuotationListBody({super.key});

  @override
  State<QuotationListBody> createState() =>
      _QuotationListBodyState();
}

class _QuotationListBodyState
    extends State<QuotationListBody> {

  final TextEditingController _searchController =
  TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context
        .read<QuotationViewModel>()
        .fetchQuotations(
      searchText:
      _searchController.text.trim(),
    );
  }

  void _searchQuotation(String value) {
    context
        .read<QuotationViewModel>()
        .fetchQuotations(
      searchText: value.trim(),
    );
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
              builder: (_) =>
              const CreateQuotationScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Consumer<QuotationViewModel>(
          builder: (
              context,
              viewModel,
              child,
              ) {
            return Column(
              children: [

                /// SEARCH
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller:
                      _searchController,
                      onChanged:
                      _searchQuotation,
                      decoration:
                      InputDecoration(
                        border:
                        InputBorder.none,
                        hintText:
                        "Search Customer, Firm, Number...",
                        icon: const Icon(
                          Icons.search,
                        ),
                        suffixIcon:
                        _searchController
                            .text
                            .isNotEmpty
                            ? IconButton(
                          icon:
                          const Icon(
                            Icons.close,
                          ),
                          onPressed: () {
                            _searchController
                                .clear();

                            _searchQuotation(
                              "",
                            );

                            setState(() {});
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                ),

                /// COUNT
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [

                      Text(
                        "${viewModel.quotations.length} Quotations",
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// LIST
                Expanded(
                  child: RefreshIndicator(
                    color: primary,
                    onRefresh: _refresh,
                    child:
                    _buildQuotationList(
                      viewModel,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuotationList(
      QuotationViewModel viewModel,
      ) {
    /// LOADING
    if (viewModel.isLoading &&
        viewModel.quotations.isEmpty) {
      return ListView(
        physics:
        AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            child: Center(
              child:
              CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    /// ERROR
    if (viewModel.errorMessage != null &&
        viewModel.quotations.isEmpty) {
      return ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            child: Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Text(
                  viewModel.errorMessage!,
                  textAlign:
                  TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// EMPTY
    if (viewModel.quotations.isEmpty) {
      return ListView(
        physics:
        AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 400,
            child: Center(
              child: Text(
                "No Quotations Found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// DATA
    return ListView.builder(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      itemCount:
      viewModel.quotations.length,
      itemBuilder:
          (context, index) {

        final quotation =
        viewModel.quotations[index];

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
                builder: (_) =>
                    QuotationDetailsDialog(
                      quotation: quotation,
                    ),
              );
            },

            onEdit: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
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
    );
  }
}