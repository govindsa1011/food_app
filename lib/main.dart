import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/helper/route_generator.dart';
import 'package:food_app/providers/recipes.dart';
import 'package:food_app/providers/userInfo.dart';
import 'package:food_app/providers/wishlist.dart';
import 'package:food_app/ui/splash.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black12,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider.value(
            value: UserInfo(),
          ),
          ChangeNotifierProvider.value(
            value: Recipes(),
          ),
          ChangeNotifierProvider.value(
            value: WishList(),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
              cupertinoOverrideTheme:
                  CupertinoThemeData(primaryColor: Colors.black),
              primaryIconTheme: IconThemeData(color: Colors.black),
              fontFamily: 'Poppins',
              primaryColorDark: Colors.black,
              accentColor: Colors.black,
              cursorColor: Colors.black,
              focusColor: Colors.black,
              primaryColor: Colors.black,
              platform: TargetPlatform.iOS),
          initialRoute: '/',
          home: Splash(),
          onGenerateRoute: RouteGenerator.generatedRoute,
          debugShowCheckedModeBanner: false,
        ));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
