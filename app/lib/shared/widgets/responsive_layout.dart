/// Responsive layout widget for different screen sizes
library responsive_layout;

import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1200;
}

/// Responsive layout builder
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= Breakpoints.tablet) {
      return desktop ?? tablet ?? mobile;
    } else if (screenWidth >= Breakpoints.mobile) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}

/// Check if current screen is mobile
bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < Breakpoints.mobile;
}

/// Check if current screen is tablet
bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width >= Breakpoints.mobile && width < Breakpoints.tablet;
}

/// Check if current screen is desktop
bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= Breakpoints.tablet;
}

/// Get max content width for centered layouts
double getMaxContentWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth >= Breakpoints.desktop) {
    return Breakpoints.desktop;
  }
  return screenWidth;
}