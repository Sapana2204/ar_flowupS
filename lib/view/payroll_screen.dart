import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Payroll"),
        backgroundColor: primary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCard(),
            const SizedBox(height: 20),

            const Text(
              "Paycheck Breakdown",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildEarningsCard(),
            const SizedBox(height: 12),

            _buildDeductionsCard(),
            const SizedBox(height: 20),

            _buildHistoryHeader(),
            const SizedBox(height: 10),

            _buildHistoryItem("Sep 2023", "\$4,500", true),
            _buildHistoryItem("Aug 2023", "\$4,320", true),

          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: buttonGradient, // ✅ your gradient
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.download, color: white),
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: primaryGradient, // ✅ using your gradient
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LATEST PAYCHECK",
            style: TextStyle(
              color: white,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "\$4,852.20",
            style: TextStyle(
              color: white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "PAYMENT DATE\nOct 25, 2023",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        size: 14, color: white),
                    SizedBox(width: 6),
                    Text(
                      "DEPOSITED",
                      style: TextStyle(
                        color: white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 🔷 Earnings Card
  Widget _buildEarningsCard() {
    return _infoCard(
      title: "Earnings",
      icon: Icons.account_balance_wallet,
      items: const [
        ["Base Salary", "\$4,200.00"],
        ["Overtime (8h)", "\$452.20"],
        ["Quarterly Bonus", "\$200.00"],
      ],
      isNegative: false,
    );
  }

  // 🔷 Deductions Card
  Widget _buildDeductionsCard() {
    return _infoCard(
      title: "Deductions",
      icon: Icons.receipt_long,
      items: const [
        ["Federal Tax", "-\$840.00"],
        ["Health Insurance", "-\$120.00"],
        ["401(k)", "-\$210.00"],
      ],
      isNegative: true,
    );
  }

  // 🔷 Reusable Card Widget
  Widget _infoCard({
    required String title,
    required IconData icon,
    required List<List<String>> items,
    required bool isNegative,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item[0]),
                  Text(
                    item[1],
                    style: TextStyle(
                      color: isNegative ? Colors.red : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 🔷 History Header
  Widget _buildHistoryHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Payment History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "VIEW ALL",
          style: TextStyle(color: primary),
        )
      ],
    );
  }

  // 🔷 History Item
  Widget _buildHistoryItem(String month, String amount, bool status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month),
          Row(
            children: [
              Text(
                amount,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Icon(
                status ? Icons.check_circle : Icons.pending,
                color: status ? Colors.green : Colors.orange,
                size: 18,
              )
            ],
          )
        ],
      ),
    );
  }
}