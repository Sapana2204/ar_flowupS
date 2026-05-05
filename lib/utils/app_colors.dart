import 'package:flutter/material.dart';

// 🌊 Primary Colors (Updated from Logo)
const Color primary = Color(0xFF1398E1);        // Main brand color
const Color darkPrimary = Color(0xFF0D4F94);    // Strong dark tone
const Color deepBlue = Color(0xFF0C5299);       // Rich supporting tone
const Color lightPrimary = Color(0xFF15A4FA);   // Bright highlight
const Color accentBlue = Color(0xFF149DF0);     // Accent / hover / focus

// ⚫ Basic Colors
const Color black = Color(0xFF000000);
const Color white = Colors.white;
const Color grey = Color(0xFF8C8E8C);
const Color lightGrey = Color(0xFFD3D3D3);

// 🎯 UI Specific
const Color buttonColor = primary;
const Color textPrimary = black;
const Color textSecondary = grey;
const Color backgroundColor = Color(0xFFF2F9FF); // keep soft contrast
const Color ultraLightPrimary = Color(0xFFEAF6FF); // adjusted to match new palette

// 🌊 Primary Gradient (Main App UI)
const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1398E1), // primary
    Color(0xFF0C5299), // deep blend
  ],
);

// 🌊 Soft Gradient (Headers / Cards)
const LinearGradient softPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF15A4FA), // light highlight
    Color(0xFF1398E1), // primary
  ],
);

// 🌊 Button Gradient (CTA Buttons)
const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF1398E1), // primary
    Color(0xFF0D4F94), // dark
  ],
);