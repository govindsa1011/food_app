import 'package:flutter/material.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:food_app/helper/route_generator.dart';

class Splash extends StatefulWidget {
  @override
  _Splash_State createState() => _Splash_State();
}

class _Splash_State extends State<Splash> {
  @override
  void initState() {
    checkIfUserAlreadyLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/splash.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/logo.png",
              height: 100,
              width: 100,
              color: Colors.white,
            ),
            Text(
              "Foodie Zone",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }

  void checkIfUserAlreadyLoggedIn() {
    new Future.delayed(
        const Duration(seconds: 3),
        () => (FDUtility.isLoggedIn().then((status) {
              if (status) {
                Navigator.of(context)
                    .pushReplacementNamed(RouteGenerator.homeRoute);
              } else {
                Navigator.of(context)
                    .pushReplacementNamed(RouteGenerator.loginRoute);
              }
            })));
  }
}
