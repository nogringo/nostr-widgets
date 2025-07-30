import 'package:demo_app/screens/home/layouts/home_large_layout.dart';
import 'package:demo_app/screens/home/layouts/home_small_layout.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) return HomeLargeLayout();
        return HomeSmallLayout();
      },
    );
  }
}
