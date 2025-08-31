import 'package:flutter/material.dart';

class PageWraper extends StatelessWidget {
  final Widget child;

  const PageWraper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: child,
        ),
      ),
    );
  }
}
