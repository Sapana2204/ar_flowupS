import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/routes/routes_names.dart';
import '../viewModel/dashboard_viewmodel.dart';
import '../viewModel/login_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().getDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = context.watch<LoginViewModel>();
    final dashboardVM = context.watch<DashboardViewModel>();

    if (dashboardVM.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final summary = dashboardVM.dashboardModel?.data?.summary ?? [];

    int openCount = 0;
    int activeCount = 0;
    int closedCount = 0;

    for (var item in summary) {
      final key = (item.key ?? '').toLowerCase();

      final value = int.tryParse(
        item.value?.replaceAll('%', '') ?? '0',
      ) ??
          0;

      if (key.contains('open')) {
        openCount = value;
      } else if (key.contains('active')) {
        activeCount = value;
      } else if (key.contains('closed')) {
        closedCount = value;
      }
    }

    final totalCalls = openCount + activeCount + closedCount;

    return RefreshIndicator(
      onRefresh: () async {
        await dashboardVM.getDashboardData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome 👋",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loginVM.userData?.name ?? "User",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              AppStrings.dashboardSubtitle,
              style: const TextStyle(
                color: textSecondary,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTON
            Row(
              children: [
                _actionButton(
                  Icons.call,
                  AppStrings.manageCall,
                      () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.callListScreen,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// FILTER
            Row(
              children: [
                _chip(AppStrings.yesterday, false),
                const SizedBox(width: 8),
                _chip(AppStrings.today, true),
                const SizedBox(width: 8),
                _chip(AppStrings.tomorrow, false),
              ],
            ),

            const SizedBox(height: 20),

            /// STATUS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.filteredStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusBox(
                        openCount.toString(),
                        AppStrings.open,
                      ),
                      _statusBox(
                        activeCount.toString(),
                        AppStrings.active,
                      ),
                      _statusBox(
                        closedCount.toString(),
                        AppStrings.closed,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// TOTAL CALLS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.assignedCalls,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          totalCalls.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("● ${AppStrings.open}"),
                      Text("● ${AppStrings.active}"),
                      Text("● ${AppStrings.closed}"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SUMMARY LIST FROM API
            // if (summary.isNotEmpty)
            //   Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: _cardDecoration(),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           "Dashboard Summary",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //
            //         const SizedBox(height: 10),
            //
            //         ...summary.map(
            //               (item) => ListTile(
            //             contentPadding: EdgeInsets.zero,
            //             title: Text(item.label ?? ""),
            //             trailing: Text(
            //               "${item.value ?? 0}",
            //               style: const TextStyle(
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            /// DASHBOARD CARDS
            if (summary.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: summary.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final item = summary[index];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.value ?? "0",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item.label ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.delta ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      IconData icon,
      String text,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: selected ? primary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _statusBox(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
        ),
      ],
    );
  }
}