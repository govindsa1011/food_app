import 'package:flutter/material.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/widget/info_header.dart';

class FDEmptyList extends StatelessWidget {
  final String message;

  FDEmptyList({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: AppTheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InfoHeader(
              title: message,
              fontSize: 18,
            )
          ],
        ));
  }
}
