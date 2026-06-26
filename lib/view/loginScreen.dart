import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/saveAccount.dart';
import '../model/savedAccount.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../viewModel/login_viewmodel.dart';
import 'forgetPassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool isPasswordVisible = false;
  List<SavedAccount> savedAccounts = [];
  SavedAccount? selectedAccount;


  @override
  void initState() {
    super.initState();
    loadAccounts();

  }



  Future<void> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList("saved_accounts") ?? [];

    savedAccounts = data
        .map((e) => SavedAccount.fromJson(jsonDecode(e)))
        .toList();

    if (savedAccounts.isNotEmpty) {
      selectedAccount = savedAccounts.first;
      emailController.text = selectedAccount!.username;
      passwordController.text = selectedAccount!.password;
      rememberMe = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final loginVM = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔷 LOGO
                Row(
                  children: [
                    Image.asset(
                      "assets/images/flowups_icon.png",
                      height: 40,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// TEXT
                Text(
                  AppStrings.welcome,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  AppStrings.signInSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),

                const SizedBox(height: 25),

                /// EMAIL
                Text(
                  AppStrings.workEmail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: AppStrings.emailHint,
                    prefixIcon: const Icon(Icons.email_outlined),

                    suffixIcon: savedAccounts.isNotEmpty
                        ? PopupMenuButton<SavedAccount>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (account) {
                        setState(() {
                          selectedAccount = account;
                          emailController.text = account.username;
                          passwordController.text = account.password;
                        });
                      },
                      itemBuilder: (context) {
                        return savedAccounts.map((account) {
                          return PopupMenuItem<SavedAccount>(
                            value: account,
                            child: Text(account.username),
                          );
                        }).toList();
                      },
                    )
                        : null,

                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// PASSWORD
                _inputField(
                  controller: passwordController,
                  label: AppStrings.password,
                  hint: AppStrings.passwordHint,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 10),

                /// REMEMBER + FORGOT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (val) {
                            setState(() {
                              rememberMe = val ?? false;
                            });
                          },
                          activeColor: primary,
                        ),
                        const Text(
                          AppStrings.rememberDevice,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                /// 🔘 LOGIN BUTTON
                GestureDetector(
                  onTap: loginVM.isLoading
                      ? null
                      : () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(AppStrings.snackbarError),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      return;
                    }

                    /// 💾 Save / Remove username
                    final prefs = await SharedPreferences.getInstance();
                    if (rememberMe) {
                      await saveAccount(
                        emailController.text.trim(),
                        passwordController.text,
                      );
                    }

                    final success = await loginVM.loginApi(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      context,
                    );

                    if (success && rememberMe) {
                      await saveAccount(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      // Reload the account list
                      await loadAccounts();
                    } else if (!rememberMe) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove("saved_accounts");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: loginVM.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        AppStrings.signIn,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),


              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 INPUT FIELD
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword ? !isPasswordVisible : false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: grey),

            /// 👁 Eye Icon
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: grey,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )
                : null,

            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}