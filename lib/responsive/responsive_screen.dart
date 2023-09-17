import 'package:flutter/material.dart';
import '../utils/global_variable.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveScreen({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {




  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      } else {
        return widget.mobileScreenLayout;
      }
    });
  }
}
