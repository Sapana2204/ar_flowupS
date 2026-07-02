import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double size;

  const AppLoader({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/loading.gif",
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}