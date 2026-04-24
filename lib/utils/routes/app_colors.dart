import 'package:flutter/material.dart';

// 🌊 Primary Colors (Deep Blue Theme)
const Color primary = Color(0xFF014AAD);        // Main brand color
const Color darkPrimary = Color(0xFF003B8E);    // Darker shade
const Color lightPrimary = Color(0xFF6EA8FE);   // Soft lighter blue
const Color deepBlue = Color(0xFF0053C1);
const Color royalBlue = Color(0xFF004EB6);

// ⚫ Basic Colors
const Color black = Color(0xFF000000);
const Color white = Colors.white;
const Color grey = Color(0xFF8C8E8C);
const Color lightGrey = Color(0xFFD3D3D3);

// 🎯 UI Specific
const Color buttonColor = primary;
const Color textPrimary = black;
const Color textSecondary = grey;
const Color backgroundColor = Color(0xFFF5F8FF); // soft bluish background
const Color ultraLightPrimary = Color(0xFFEAF1FF);

// 🌊 Primary Gradient (Main App UI)
const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF014AAD), // primary
    Color(0xFF0053C1), // lighter blend
  ],
);

// 🌊 Soft Gradient (Headers / Cards Background)
const LinearGradient softPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF6EA8FE), // light blue
    Color(0xFF014AAD), // primary
  ],
);

// 🌊 Button Gradient (CTA Buttons)
const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF014AAD), // primary
    Color(0xFF003B8E), // darker
  ],
);