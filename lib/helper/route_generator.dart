import 'package:flutter/material.dart';
import 'package:food_app/ui/add_new_recipe.dart';
import 'package:food_app/ui/dashboard_screen.dart';
import 'package:food_app/ui/recipeInfoScreen.dart';

import '../ui/login.dart';

class RouteGenerator {
  static const loginRoute = 'loginRoute';
  static const homeRoute = 'homeRoute';
  static const detailRoute = 'detailRoute';
  static const addNewRoute = 'addNewRoute';

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    final args = settings.arguments;
    if (settings.name is String) {
      switch (settings.name) {
        case loginRoute:
          return MaterialPageRoute(builder: (_) => Login());
        case homeRoute:
          return MaterialPageRoute(builder: (_) => DashBoard_Screen());
        case detailRoute:
          return MaterialPageRoute(builder: (_) => RecipeInfoScreen(args));
        case addNewRoute:
          return MaterialPageRoute(builder: (_) => AddNewRecipe());
        default:
          return _errorRoute();
      }
    } else {
      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Unexpected navigation. please go back to continue'),
        ),
      );
    });
  }
}
