import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/routes/routes_names.dart';
import '../viewModel/dashboard_viewmodel.dart';
import '../viewModel/login_viewmodel.dart';
import 'package:pie_chart/pie_chart.dart';

import 'callsList_screen.dart';

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

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = context.watch<LoginViewModel>();
    final dashboardVM = context.watch<DashboardViewModel>();

    if (dashboardVM.loading) {
      return const Center(
        child: Image(
          image: AssetImage("assets/images/loading.gif"),
          width: 100,
          height: 100,
        ),
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
    // final ticketStatus =
    //     dashboardVM.dashboardModel?.data?.charts?.ticketStatus ?? [];
    //
    // final Map<String, double> pieData = {};
    // final List<Color> pieColors = [];
    //
    // int totalTickets = 0;
    //
    // for (final item in ticketStatus) {
    //   if (item is Map<String, dynamic>) {
    //     // final int value = item['value'] ?? 0;
    //
    //     final value = int.tryParse(
    //       item['value']?.toString() ?? '0',
    //     ) ??
    //         0;
    //
    //     pieData[item['label'] ?? 'Unknown'] = value.toDouble();
    //
    //     totalTickets += value;
    //
    //     if (item['color'] != null) {
    //       pieColors.add(hexToColor(item['color']));
    //     }
    //   }
    // }

    final ticketStatus =
        dashboardVM.dashboardModel?.data?.charts?.ticketStatus ?? [];

    final Map<String, double> pieData = {};
    final List<Color> pieColors = [];

    int totalTickets = 0;

    for (final item in ticketStatus) {
      if (item is Map<String, dynamic>) {
        final value = int.tryParse(
          item['value']?.toString() ?? '0',
        ) ??
            0;

        final label = item['label']?.toString() ?? 'Unknown';

        if (value > 0) {
          pieData[label] = value.toDouble();
          totalTickets += value;
        }

        if (item['color'] != null) {
          pieColors.add(
            hexToColor(item['color'].toString()),
          );
        }
      }
    }


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
                  AppStrings.manageTicket,
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

            /// TOTAL CALLS CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.assignedTickets,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 180,
                    child: Row(
                      children: [
                        /// PIE CHART / EMPTY STATE
                        Expanded(
                          flex: 2,
                          child: pieData.isEmpty || totalTickets == 0
                              ? const Center(
                            child: Text(
                              "No ticket data available",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                              : PieChart(
                            dataMap: pieData,
                            animationDuration: const Duration(milliseconds: 800),
                            chartRadius: 90,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 25,
                            centerText: totalTickets.toString(),
                            colorList: pieColors,
                            legendOptions: const LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValues: false,
                            ),
                          ),
                        ),

                        // const SizedBox(width: 16),

                        /// STATUS LEGEND
                        Expanded(
                          flex: 1,
                          child: ticketStatus.isEmpty
                              ? const Center(
                            child: Text(
                              "No status data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ticketStatus.map<Widget>((item) {
                              if (item is Map<String, dynamic>) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: _legendItem(
                                    hexToColor(item['color'] ?? '#0078D4'),
                                    '${item['label']} (${item['value']})',
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),

            const SizedBox(height: 20),



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

                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      final label = (item.label ?? "").toLowerCase();

                      if (label.contains("total customer")) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.customersListScreen,
                        );
                      } else if (label.contains("open ticket")) {


                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CallsListScreen(
                              searchText: "open",
                            ),
                          ),
                        );

                      } else if (label.contains("today follow-ups")) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.callListScreen,
                        );
                      } else if (label.contains("amc active")) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.amcListScreen,
                          arguments: "active",
                        );
                      } else if (label.contains("amc expiring")) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.amcListScreen,
                          arguments: "expiring",
                        );
                      } else if (label.contains("amc expired")) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.amcListScreen,
                          arguments: "expired",
                        );
                      }
                    },
                    child: Container(
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
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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