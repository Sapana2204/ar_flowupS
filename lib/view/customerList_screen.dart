import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/widgets/customerCard.dart';
import '../utils/app_colors.dart';
import '../viewmodel/customers_viewmodel.dart';
import 'createCustomer_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    final vm = Provider.of<CustomersViewModel>(context, listen: false);
    vm.fetchCustomers();

    /// 🔽 Pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        vm.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text("Customers"),
        backgroundColor: primary,
      ),

      /// ➕ ADD CUSTOMER
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCustomerScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Consumer<CustomersViewModel>(
                  builder: (context, vm, child) {
                    return TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,

                      /// 🔍 LIVE SEARCH (debounce)
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        _debounce = Timer(const Duration(milliseconds: 300), () {
                          vm.filterCustomers(value); // ✅ LOCAL SEARCH
                        });
                      },

                      /// 🔎 SEARCH BUTTON
                      onSubmitted: (value) {
                        vm.filterCustomers(value); // ✅ LOCAL
                      },

                      decoration: InputDecoration(
                        hintText: "Search customers, names, mobile...",
                        border: InputBorder.none,
                        icon: const Icon(Icons.search),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            vm.filterCustomers(""); // ✅ reset list
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 📋 LIST
            Expanded(
              child: Consumer<CustomersViewModel>(
                builder: (context, vm, child) {

                  /// 🔄 LOADING
                  if (vm.isLoading && vm.customers.isEmpty) {
                    return Center(
                      child: Image.asset(
                        "assets/images/loading.gif",
                        width: 100,
                        height: 100,
                      ),
                    );
                  }

                  /// ❌ ERROR
                  if (vm.error.isNotEmpty) {
                    return Center(child: Text(vm.error));
                  }

                  /// 🚫 EMPTY
                  if (vm.customers.isEmpty) {
                    return const Center(
                      child: Text("No customers found"),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => vm.fetchCustomers(isRefresh: true),
                    color: primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      itemCount:
                      vm.customers.length + (vm.hasMore ? 1 : 0),

                      itemBuilder: (context, index) {

                        /// 🔽 PAGINATION LOADER
                        if (index == vm.customers.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final customer = vm.customers[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomerCard(customer: customer),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}