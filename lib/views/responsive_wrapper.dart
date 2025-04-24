import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Define padding based on screen size
    double horizontalPadding = 0;
    
    if (screenWidth > 1200) {
      // Large desktop
      horizontalPadding = screenWidth * 0.2;
    } else if (screenWidth > 800) {
      // Small desktop / tablet landscape
      horizontalPadding = screenWidth * 0.1;
    } else if (screenWidth > 600) {
      // Tablet portrait
      horizontalPadding = 20;
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: child,
    );
  }
}