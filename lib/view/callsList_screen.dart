import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../res/widgets/callCard.dart';
import '../utils/app_colors.dart';
import '../viewmodel/query_viewmodel.dart';
import '../viewmodel/tickets_viewmodel.dart';
import 'registerCall_screen.dart';

class CallsListScreen extends StatefulWidget {
  const CallsListScreen({super.key});

  @override
  State<CallsListScreen> createState() => _CallsListScreenState();
}

class _CallsListScreenState extends State<CallsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    final ticketVm = Provider.of<TicketsViewModel>(context, listen: false);
    ticketVm.fetchTickets();

    /// 🔥 PRELOAD ALL DROPDOWN DATA HERE
    final queryVm = Provider.of<QueryViewModel>(context, listen: false);

    Future.microtask(() {
      queryVm.fetchQueryTypes();
      queryVm.fetchPriorityLevels();
      queryVm.fetchAdmins();
      queryVm.fetchClients();
      queryVm.fetchStatusList();
    });

    /// Pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ticketVm.loadMore();
      }
    });
  }

  String formatDate(String? date) {
    if (date == null) return "";
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Call List"),
        backgroundColor: primary,
      ),

      /// 🔵 FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(Icons.add_call, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterCallScreen(),
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔍 SEARCH BAR (UI only for now)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Consumer<TicketsViewModel>(
                  builder: (context, vm, child) {
                    return TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,

                      /// 🔍 LIVE SEARCH
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        _debounce = Timer(const Duration(milliseconds: 300), () {
                          final vm = Provider.of<TicketsViewModel>(context, listen: false);
                          vm.filterTickets(value);   // ✅ LOCAL SEARCH
                        });
                      },

                      /// 🔎 SEARCH BUTTON
                      onSubmitted: (value) {
                        final vm = Provider.of<TicketsViewModel>(context, listen: false);
                        vm.filterTickets(value);
                      },

                      decoration: InputDecoration(
                        hintText: "Search calls, names, or IDs...",
                        border: InputBorder.none,
                        icon: const Icon(Icons.search),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();

                            final vm = Provider.of<TicketsViewModel>(context, listen: false);
                            vm.filterTickets("");
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 📋 LIST FROM API
            Expanded(
              child: Consumer<TicketsViewModel>(
                builder: (context, vm, child) {

                  /// 🔄 LOADING
                  if (vm.isLoading && vm.ticketsList.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primary,   // 🔵 set your primary color
                        ),
                      ),
                    );                }

                  /// ❌ ERROR
                  if (vm.error.isNotEmpty) {
                    return Center(child: Text(vm.error));
                  }

                  /// 🚫 EMPTY
                  if (vm.ticketsList.isEmpty) {
                    return const Center(child: Text("No calls found"));
                  }

                  return RefreshIndicator(
                    onRefresh: vm.refreshTickets,
                    color: primary,              // 🔵 spinner color
                    backgroundColor: Colors.white, // optional
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vm.ticketsList.length +
                          (vm.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {

                        /// 🔽 Loader at bottom (pagination)
                        if (index == vm.ticketsList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: CircularProgressIndicator()),
                          );
                        }

                        final ticket = vm.ticketsList[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CallCard(ticket: ticket)
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
    _debounce?.cancel();          // stop timer
    _searchController.dispose();  // clean controller
    super.dispose();
  }
}