import 'package:flutter/material.dart';
import '../utils/routes/app_colors.dart';
import 'homeScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                /// 🔷 LOGO + TITLE
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 40,
                    ),
                    const SizedBox(width: 10),

                  ],
                ),

                const SizedBox(height: 25),

                /// 👋 WELCOME TEXT
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Sign in to your workspace to continue.",
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),

                const SizedBox(height: 25),

                /// 📧 EMAIL FIELD
                _inputField(
                  label: "WORK EMAIL",
                  hint: "name@company.com",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 16),

                /// 🔒 PASSWORD FIELD
                _inputField(
                  label: "PASSWORD",
                  hint: "Enter password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 10),

                /// 🔗 FORGOT PASSWORD + REMEMBER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (val) {},
                          activeColor: primary,
                        ),
                        Text(
                          "Remember this device",
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),

                /// 🔘 SIGN IN BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In →",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),



                /// SIGNUP
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: textSecondary),
                      children: [
                        TextSpan(
                          text: "Request Access",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 INPUT FIELD
  Widget _inputField({
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
          style: TextStyle(
            fontSize: 11,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: grey),
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