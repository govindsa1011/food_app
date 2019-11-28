import 'package:flutter/material.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:food_app/helper/route_generator.dart';

class FDAlertDialog {
  static void showAlert(context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Foodie"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showConfirmation(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text('Foodie!'),
              content: new Text(
                message,
                style: new TextStyle(fontSize: 20.0),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      FDUtility.clearUserDetails();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteGenerator.loginRoute, (_) => false);
                    },
                    child: new Text('Yes')),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('No')),
              ],
            ));
  }
}
