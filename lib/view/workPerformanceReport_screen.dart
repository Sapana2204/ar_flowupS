import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/assignee_model.dart';
import '../model/company_model.dart';
import '../viewmodel/workPerformance_viewmodel.dart';
import '../viewmodel/workReport_viewmodel.dart';

class PerformanceReportScreen extends StatefulWidget {
  const PerformanceReportScreen({super.key});

  @override
  State<PerformanceReportScreen> createState() => _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  /// 🔹 FILTER VALUES
  AssigneeModel? selectedEmployee;
  CompanyModel? selectedCompany;

  DateTimeRange? selectedDateRange;

  String searchQuery = "";
  final PageController _analyticsController = PageController();

  int currentPage = 0;
  bool isFilterApplied = false;
  List<Map<String, dynamic>> filteredTickets = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context
          .read<WorkReportViewModel>()
          .loadWorkReportData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Work Performance"),
          actions: [
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.8,
                end: 1.2,
              ),
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: isFilterApplied ? 1 : value,
                  child: child,
                );
              },
              onEnd: () {
                if (!isFilterApplied) {
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isFilterApplied
                      ? Colors.transparent
                      : Colors.orange.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_alt,
                    color: isFilterApplied
                        ? Colors.white
                        : Colors.orange,
                  ),
                  onPressed: _openFilterSheet,
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: "excel", child: Text("Export Excel")),
                const PopupMenuItem(value: "pdf", child: Text("Export PDF")),
              ],
              onSelected: (val) {
                if (val == "excel") _exportExcel();
                if (val == "pdf") _exportPDF();
              },
            )
          ],
        ),


      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                isScrollable: false,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: "Tickets"),
                  Tab(text: "Analytics"),
                  Tab(text: "Performance"),
                  Tab(text: "Activity"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _ticketsTab(),      // Image design screen
                  _analyticsTab(),    // Future
                  _performanceTab(),  // Future
                  _activityTab(),     // Future
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketsTab() {
    return Consumer<WorkPerformanceViewModel>(
      builder: (context, vm, child) {

        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.report == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  "Select Employee and Date Range",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Apply filters to view performance report",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [

              /// Selected User Card
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "SELECTED USER",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            vm.user?.name ?? "-",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            vm.user?.email ?? "",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Summary Grid
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.0,
                  children: [

                    _ticketMetricCard(
                      "Assigned",
                      "${vm.assigned}",
                      Icons.assignment,
                    ),

                    _ticketMetricCard(
                      "Closed",
                      "${vm.closed}",
                      Icons.check_circle,
                    ),

                    _ticketMetricCard(
                      "Pending",
                      "${vm.pending}",
                      Icons.schedule,
                    ),

                    _ticketMetricCard(
                      "Delegated",
                      "${vm.delegated}",
                      Icons.send,
                    ),

                    _ticketMetricCard(
                      "Overdue",
                      "${vm.overdue}",
                      Icons.warning_amber,
                    ),

                    _ticketMetricCard(
                      "Avg Resolution",
                      "${vm.avgResolutionTime} hrs",
                      Icons.timer,
                    ),

                    _ticketMetricCard(
                      "Productivity",
                      "${vm.productivityScore}",
                      Icons.speed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _ticketMetricCard(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsTab() {
    return Consumer<WorkPerformanceViewModel>(
      builder: (context, vm, child) {

        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.report == null) {
          return const Center(
            child: Text("Apply filters to view analytics"),
          );
        }

        return Column(
          children: [
            Expanded(
              child: PageView(
                controller: _analyticsController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [

                  /// PAGE 1
                  _monthlyProductivityPage(vm),

                  /// PAGE 2
                  _ticketDistributionPage(vm),

                  /// PAGE 3
                  _dailyClosurePage(vm),

                  /// PAGE 4
                  _pendingVsClosedPage(vm),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(4),
                  width: currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.blue
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _monthlyProductivityPage(
      WorkPerformanceViewModel vm) {
    return _chartCard(
      title: "User Monthly Productivity",
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >=
                        vm.monthlyProductivity.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        vm.monthlyProductivity[value.toInt()]
                            .label ??
                            "",
                      ),
                    );
                  },
                ),
              ),
            ),

            barGroups: List.generate(
              vm.monthlyProductivity.length,
                  (index) {
                final item =
                vm.monthlyProductivity[index];

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: double.tryParse(
                          item.value.toString()) ??
                          0,
                      width: 45,
                      borderRadius:
                      BorderRadius.circular(6),
                      color: Colors.blue,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _ticketDistributionPage(
      WorkPerformanceViewModel vm) {

    return _chartCard(
      title: "Ticket Status Distribution",
      child: Column(
        children: [

          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 60,
                sectionsSpace: 3,
                sections: vm.ticketStatusDistribution.map((e) {

                  final color = e.color != null
                      ? Color(
                    int.parse(
                      e.color!.replaceFirst('#', '0xFF'),
                    ),
                  )
                      : Colors.grey;

                  return PieChartSectionData(
                    value: (e.value ?? 0).toDouble(),
                    color: color,
                    radius: 40,
                    title: "",
                  );
                }).toList(),
              ),
            ),
          ),

          /// Dynamic Legend
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 16,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: vm.ticketStatusDistribution.map((e) {

                final color = e.color != null
                    ? Color(
                  int.parse(
                    e.color!.replaceFirst('#', '0xFF'),
                  ),
                )
                    : Colors.grey;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "${e.label} (${e.value})",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyClosurePage(
      WorkPerformanceViewModel vm) {

    return _chartCard(
      title: "Daily Closure Trend",
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: (vm.dailyClosureTrend
                .map((e) => e.value ?? 0)
                .fold<int>(0, (a, b) => a > b ? a : b))
                .toDouble() +
                2,

            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {

                    final index = value.toInt();

                    if (index < 0 ||
                        index >= vm.dailyClosureTrend.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        vm.dailyClosureTrend[index].label ?? "",
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  },
                ),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                isCurved:
                vm.dailyClosureTrend.length > 1,

                color: Colors.teal,
                barWidth: 3,

                dotData: FlDotData(
                  show: true,
                ),

                belowBarData: BarAreaData(
                  show: false,
                ),

                spots: List.generate(
                  vm.dailyClosureTrend.length,
                      (index) => FlSpot(
                    index.toDouble(),
                    (vm.dailyClosureTrend[index].value ?? 0)
                        .toDouble(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pendingVsClosedPage(
      WorkPerformanceViewModel vm) {

    final data = vm.pendingVsClosed;

    return _chartCard(
      title: "Pending vs Closed Comparison",
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,

            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text("Pending");

                      case 1:
                        return const Text("Closed");

                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ),

            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY:
                    (data?.pending ?? 0).toDouble(),
                    width: 55,
                    color: Colors.orange,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ],
              ),

              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY:
                    (data?.closed ?? 0).toDouble(),
                    width: 55,
                    color: Colors.green,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _performanceTab() {
    return Consumer<WorkPerformanceViewModel>(
      builder: (context, vm, child) {

        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.report == null) {
          return const Center(
            child: Text(
              "Apply filters to view tickets",
            ),
          );
        }

        if (vm.tickets.isEmpty) {
          return const Center(
            child: Text("No tickets found"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.tickets.length,
          itemBuilder: (context, index) {

            final ticket = vm.tickets[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border(
                  left: BorderSide(
                    color: ticket.ticketStatus == "Closed"
                        ? Colors.green
                        : Colors.orange,
                    width: 5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket.ticketNo ?? "-",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        _statusChip(
                          ticket.ticketStatus ?? "-",
                          ticket.ticketStatus == "Closed"
                              ? Colors.green
                              : Colors.orange,
                        ),

                        const Spacer(),

                        _priorityChip(
                          ticket.ticketPriority ?? "-",
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                          Colors.blue.shade50,
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            ticket.customerName ?? "-",
                            style: const TextStyle(
                              fontWeight:
                              FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Divider(
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [

                        Expanded(
                          child: _infoBox(
                            Icons.calendar_month,
                            "Assigned",
                            ticket.assignedDate ?? "-",
                          ),
                        ),

                        Expanded(
                          child: _infoBox(
                            Icons.event_busy,
                            "Due",
                            ticket.dueDate ?? "-",
                          ),
                        ),

                        Expanded(
                          child: _infoBox(
                            Icons.timer,
                            "Time",
                            "${ticket.resolutionTime ?? 0} hrs",
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
  Widget _statusChip(
      String text,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
  Widget _priorityChip(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: Colors.red.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
  Widget _infoBox(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityTab() {
    return Consumer<WorkPerformanceViewModel>(
      builder: (context, vm, child) {

        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vm.report == null) {
          return const Center(
            child: Text(
              "Apply filters to view activities",
            ),
          );
        }

        if (vm.activities.isEmpty) {
          return const Center(
            child: Text("No activities found"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.activities.length,
          itemBuilder: (context, index) {

            final activity =
            vm.activities[index];

            return _activityCard(
              date:
              activity.createdDate?.toString() ?? "",
              description:
              activity.message?.toString() ?? "",
              isLast:
              index == vm.activities.length - 1,
            );
          },
        );
      },
    );
  }
  Widget _activityCard({
    required String date,
    required String description,
    required bool isLast,
  }) {
    const Color color = Colors.blue;
    const IconData icon = Icons.history;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [

                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Activity Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// 🔹 FILTER SHEET
  void _openFilterSheet() {
    final workReportvm = context.read<WorkReportViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF4F6FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 HEADER
                    const Center(
                      child: Text(
                        "Filters",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 20),


                    /// 🔹 DATE RANGE
                    _sectionTitle("DATE RANGE"),
                    Row(
                      children: [
                        Expanded(
                          child: _dateField(
                            selectedDateRange?.start,
                            () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedDateRange = DateTimeRange(
                                    start: picked,
                                    end: selectedDateRange?.end ?? picked,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("TO"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dateField(
                            selectedDateRange?.end,
                            () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  selectedDateRange = DateTimeRange(
                                    start: selectedDateRange?.start ?? picked,
                                    end: picked,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (workReportvm.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
            else ...[
                    /// 🔹 DROPDOWNS
                    _sectionTitle("EMPLOYEE"),

                    DropdownButtonFormField<AssigneeModel>(
                      value: selectedEmployee,
                      hint: const Text("Select Employee"),
                      items: workReportvm.assigneeList.map((employee) {
                        return DropdownMenuItem<AssigneeModel>(
                          value: employee,
                          child: Text(employee.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedEmployee = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                      
],
                    const SizedBox(height: 20),

                    /// 🔹 ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {

                              setModalState(() {
                                selectedEmployee = null;
                                selectedCompany = null;
                                selectedDateRange = null;
                              });

                              context
                                  .read<WorkPerformanceViewModel>()
                                  .clearData();

                              Navigator.pop(context);
                            },
                            child: const Text("Reset"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {

                              if (selectedEmployee == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select employee"),
                                  ),
                                );
                                return;
                              }

                              if (selectedDateRange == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select date range"),
                                  ),
                                );
                                return;
                              }

                              final fromDate =
                              DateFormat('yyyy-MM-dd')
                                  .format(selectedDateRange!.start);

                              final toDate =
                              DateFormat('yyyy-MM-dd')
                                  .format(selectedDateRange!.end);

                              await context
                                  .read<WorkPerformanceViewModel>()
                                  .getPerformanceReport(
                                userId:
                                selectedEmployee!.adminId.toString(),
                                fromDate: fromDate,
                                toDate: toDate,
                              );

                              Navigator.pop(context);
                            },
                            child: const Text("Apply"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 1,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dateField(DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null
                  ? "dd-mm-yyyy"
                  : DateFormat('dd-MM-yyyy').format(date),
              style: const TextStyle(fontSize: 13),
            ),
            const Icon(Icons.calendar_today, size: 16),
          ],
        ),
      ),
    );
  }





  /// 🔹 EXPORT (BASIC PLACEHOLDER)
  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Excel export coming soon")),
    );
  }

  void _exportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF export coming soon")),
    );
  }

  @override
  void dispose() {
    _analyticsController.dispose();
    super.dispose();
  }
}
