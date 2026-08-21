import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_new_project/viewModel/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../res/widgets/callCard.dart';
import '../utils/app_colors.dart';
import '../viewmodel/query_viewmodel.dart';
import '../viewmodel/tickets_viewmodel.dart';
import 'registerCall_screen.dart';

class CallsListScreen extends StatefulWidget {
  final String? status;
  final String? searchText;


  const CallsListScreen({super.key,    this.status, this.searchText
  });

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();

      if (widget.searchText != null && widget.searchText!.isNotEmpty) {
        // From Dashboard
        ticketVm.searchTickets(
          widget.searchText!,
          status: "active",
        );

        _searchController.text = widget.searchText!;
      } else {
        // Normal Tickets screen
        ticketVm.searchTickets(
          "",
          status: "active",
        );

        _searchController.clear();
      }
    });

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
      backgroundColor: primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
          // onPressed: () async {
          //   await context.read<TicketsViewModel>().resetAssignee();
          //   if (context.mounted) {
          //     Navigator.pop(context);
          //   }
          // }

        onPressed: () async {
          await context.read<TicketsViewModel>().resetTicketFilters();

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text("Tickets"),
        actions: [
          Consumer2<LoginViewModel, TicketsViewModel>(
            builder: (_, loginVm, ticketVm, __) {
              // Show My Tickets / All Tickets only for Admin & Super Admin
              if (!loginVm.canViewAllTickets) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                tooltip: "Ticket View",
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),

                onSelected: (value) async {
                  await ticketVm.setViewAll(value);
                },

                itemBuilder: (_) => [
                  PopupMenuItem<String>(
                    value: "N",
                    child: Row(
                      children: [
                        Icon(
                          ticketVm.viewAll == "N"
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: primary,
                        ),
                        const SizedBox(width: 10),
                        const Text("My Tickets"),
                      ],
                    ),
                  ),

                  PopupMenuItem<String>(
                    value: "Y",
                    child: Row(
                      children: [
                        Icon(
                          ticketVm.viewAll == "Y"
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: primary,
                        ),
                        const SizedBox(width: 10),
                        const Text("All Tickets"),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Consumer2<QueryViewModel, TicketsViewModel>(
          //   builder: (_, queryVm, ticketVm, __) {
          //     return Padding(
          //       padding: const EdgeInsets.only(right: 12),
          //       child: DropdownButtonHideUnderline(
          //         child: DropdownButton<int>(
          //           value: ticketVm.selectedAssigneeId,
          //           dropdownColor: Colors.white,
          //           iconEnabledColor: Colors.white,
          //           style: const TextStyle(
          //             color: Colors.black,
          //             fontSize: 14,
          //           ),
          //           isDense: true,
          //           items: [
          //             const DropdownMenuItem(
          //               value: 0,
          //               child: Text("All Assignees"),
          //             ),
          //             ...queryVm.adminList.map(
          //                   (admin) => DropdownMenuItem(
          //                 value: admin.adminID!,
          //                 child: Text(admin.name ?? ""),
          //               ),
          //             ),
          //           ],
          //           onChanged: (value) {
          //             if (value != null) {
          //               ticketVm.setAssignee(value);
          //             }
          //           },
          //         ),
          //       ),
          //     );
          //   },
          // ),

          Consumer<TicketsViewModel>(
            builder: (_, ticketVm, __) {
              const statusList = [
                "Open",
                "In Progress",
                "Pending",
                "Resolved",
                "Closed",
              ];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ticketVm.selectedTicketStatus.isEmpty
                        ? null
                        : ticketVm.selectedTicketStatus,

                    hint: const Text(
                      "Status",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),

                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.white,

                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    isDense: true,

                    items: [
                      const DropdownMenuItem<String>(
                        value: "",
                        child: Text("All Status"),
                      ),

                      ...statusList.map(
                            (status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      ),
                    ],

                    onChanged: (value) {
                      if (value != null) {
                        ticketVm.setTicketStatus(value);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
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
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Consumer<TicketsViewModel>(
                  builder: (context, vm, child) {
                    return TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,

                      /// 🔍 LIVE SEARCH
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();

                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          final vm = Provider.of<TicketsViewModel>(context, listen: false);
                          vm.searchTickets(value); // ✅ API SEARCH
                        });
                      },

                      onSubmitted: (value) {
                        final vm = Provider.of<TicketsViewModel>(context, listen: false);
                        vm.searchTickets(value); // ✅ API SEARCH
                      },

                      decoration: InputDecoration(
                        hintText: "Type names, IDs or status...",
                        border: InputBorder.none,
                        icon: const Icon(Icons.search),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();

                            final vm = Provider.of<TicketsViewModel>(context, listen: false);
                            vm.searchTickets(""); // reload all tickets from API
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
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Image.asset(
                          "assets/images/loading.gif",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  }

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