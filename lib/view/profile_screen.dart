import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../viewModel/profile_viewmodel.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileViewModel>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        if (vm.loading) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: Image.asset(
                "assets/images/loading.gif",
                width: 100,
                height: 100,
              ),
            ),
          );
        }

        final profile = vm.profileModel?.data;
        final name = profile?.name?.trim().isNotEmpty == true
            ? profile!.name!
            : "User";

        return Scaffold(
          backgroundColor: backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 230,
                pinned: true,
                elevation: 0,
                centerTitle: true,
                backgroundColor: primary,
                title: const Text(
                  "Profile",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: primaryGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 28),

                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundColor: lightPrimary.withOpacity(0.18),
                              child: Text(
                                name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile?.roleName ?? "-",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                  child: Column(
                    children: [
                      _summaryCard(profile),
                      const SizedBox(height: 16),

                      _sectionCard(
                        title: "Account Details",
                        children: [
                          _profileTile(
                            Icons.person_outline,
                            "Username",
                            profile?.userName ?? "",
                          ),
                          _profileTile(
                            Icons.badge_outlined,
                            "Admin ID",
                            profile?.adminID?.toString() ?? "",
                          ),
                          _profileTile(
                            Icons.verified_user_outlined,
                            "Status",
                            profile?.status ?? "Active",
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _sectionCard(
                        title: "Contact Information",
                        children: [
                          _profileTile(
                            Icons.email_outlined,
                            "Email",
                            profile?.email ?? "",
                          ),
                          _profileTile(
                            Icons.phone_outlined,
                            "Contact Number",
                            profile?.contactNo ?? "",
                          ),
                          _profileTile(
                            Icons.chat_outlined,
                            "Whatsapp",
                            profile?.whatsappNo ?? "",
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _sectionCard(
                        title: "Business Information",
                        children: [
                          _profileTile(
                            Icons.business_outlined,
                            "Company",
                            profile?.companyName ?? "",
                          ),
                          _profileTile(
                            Icons.home_outlined,
                            "Address",
                            removeHtmlTags(profile?.address),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _sectionCard(
                        title: "Personal Details",
                        children: [
                          _profileTile(
                            Icons.calendar_month_outlined,
                            "DOB",
                            profile?.dateOfBirth ?? "",
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _handleLogout(context),
                          icon: const Icon(Icons.logout),
                          label: const Text("Sign Out"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.shade200),
                            backgroundColor: Colors.red.shade50,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String removeHtmlTags(String? html) {
    if (html == null || html.isEmpty) return "";

    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  Widget _summaryCard(dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _summaryItem(
            Icons.business_center_outlined,
            "Role",
            profile?.roleName ?? "-",
          ),
          _divider(),
          _summaryItem(
            Icons.apartment_outlined,
            "Company",
            profile?.companyName ?? "-",
          ),
          _divider(),
          _summaryItem(
            Icons.circle,
            "Status",
            profile?.status ?? "Active",
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
      IconData icon,
      String title,
      String value, {
        Color? iconColor,
      }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: iconColor ?? primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.isEmpty ? "-" : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 46,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade200,
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _profileTile(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: lightPrimary.withOpacity(0.14),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }
}