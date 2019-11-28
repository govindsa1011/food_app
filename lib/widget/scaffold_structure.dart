import 'package:flutter/material.dart';

class FDScaffold extends StatelessWidget {
  final String title;
  final Widget controller;

  FDScaffold({this.title, this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller,
    );
  }
}
