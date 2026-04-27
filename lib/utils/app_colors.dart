import 'package:flutter/material.dart';

// 🌊 Primary Colors (Sky Blue Theme)
const Color primary = Color(0xFF1399EA);        // Main brand color
const Color darkPrimary = Color(0xFF0F7DC2);    // Slightly darker shade
const Color lightPrimary = Color(0xFF5EC2FF);   // Soft lighter blue
const Color deepBlue = Color(0xFF0A6BB8);       // Rich supporting tone
const Color royalBlue = Color(0xFF117FD1);      // Mid accent shade

// ⚫ Basic Colors
const Color black = Color(0xFF000000);
const Color white = Colors.white;
const Color grey = Color(0xFF8C8E8C);
const Color lightGrey = Color(0xFFD3D3D3);

// 🎯 UI Specific
const Color buttonColor = primary;
const Color textPrimary = black;
const Color textSecondary = grey;
const Color backgroundColor = Color(0xFFF2F9FF); // softer bluish background
const Color ultraLightPrimary = Color(0xFFE7F4FF);

// 🌊 Primary Gradient (Main App UI)
const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1399EA), // primary
    Color(0xFF0A6BB8), // deeper blend
  ],
);

// 🌊 Soft Gradient (Headers / Cards Background)
const LinearGradient softPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF5EC2FF), // light blue
    Color(0xFF1399EA), // primary
  ],
);

// 🌊 Button Gradient (CTA Buttons)
const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF1399EA), // primary
    Color(0xFF0F7DC2), // darker
  ],
);