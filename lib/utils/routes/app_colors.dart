import 'package:flutter/material.dart';

// 🌊 Primary Colors (Based on Logo)
Color primary = const Color(0xFF1399EA);   // Main brand color
Color darkPrimary = const Color(0xFF014AAD);
Color lightPrimary = const Color(0xFF38B7FF);
Color deepBlue = const Color(0xFF0053C1);
Color royalBlue = const Color(0xFF004EB6);

// ⚫ Basic Colors
Color black = const Color(0xFF000000);
Color white = Colors.white;
Color grey = const Color(0xFF8C8E8C);
Color lightGrey = const Color(0xFFD3D3D3);

// 🎯 UI Specific
Color buttonColor = primary;
Color textPrimary = black;
Color textSecondary = grey;
Color backgroundColor = const Color(0xFFF5FAFF); // soft bluish background

// 🌊 Primary Gradient (App Background)
LinearGradient primaryGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1399EA), // primary
    Color(0xFF0053C1), // deeper tone
  ],
);

// 🌊 Soft Gradient (Modern UI Background)
LinearGradient softPrimaryGradient = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF38B7FF),
    Color(0xFF1399EA),
  ],
);

// 🌊 Button Gradient
LinearGradient buttonGradient = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF1399EA),
    Color(0xFF004EB6),
  ],
);