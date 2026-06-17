import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/amc_model.dart';
import '../res/widgets/amcCard.dart';
import '../utils/app_colors.dart';
import '../viewmodel/amc_viewmodel.dart';

class AMCListScreen extends StatefulWidget {
  const AMCListScreen({super.key});

  @override
  State<AMCListScreen> createState() => _AMCListScreenState();
}

class _AMCListScreenState extends State<AMCListScreen> {
  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AMCViewModel>().loadAMCReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("AMC Management"),
        backgroundColor: primary,
      ),
      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText:
                  "Search customer / company / mobile",
                ),
                onChanged: (value) {
                  context
                      .read<AMCViewModel>()
                      .searchAMC(value);
                },
              ),
            ),
          ),

          Expanded(
            child: Consumer<AMCViewModel>(
              builder: (_, vm, __) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (vm.amcList.isEmpty) {
                  return const Center(
                    child: Text("No AMC Found"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: vm.refreshAMC,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: vm.amcList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 12),
                        child: AMCReminderCard(
                          data: vm.amcList[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}