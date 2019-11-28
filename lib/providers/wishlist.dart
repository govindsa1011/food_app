import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_app/helper/constants.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:food_app/models/recipe.dart';

class WishList extends ChangeNotifier {
  List<Recipe> _items = [];

  List<Recipe> get favoriteRecipes {
    return [..._items];
  }

  Recipe findById(int id) {
    return _items.length > 0
        ? _items.firstWhere((item) {
            return item.id == id;
          })
        : null;
  }

  removeFromLocal(int id) {
    final currentItem = findById(id);
    if (currentItem != null) {
      _items.remove(currentItem);
    }
    notifyListeners();
  }

  addToLocal(Recipe recipe) {
    _items.insert(0, recipe);
  }

  Future<void> fetchWishList() async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);

    try {
      final resp = await dio.get(FDAPIConstants.getWishList);
      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final data = resp.data;
        final List<Recipe> favRecipes = [];
        if (data is List<dynamic>) {
          data.forEach((recipe) {
            Recipe rec = Recipe.fromJson(recipe);
            rec.inWishList = true;
            favRecipes.add(rec);
          });
        }
        _items = favRecipes;
        notifyListeners();
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }

  Future<dynamic> addToWishList(int recipeId) async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);

    try {
      final resp = await dio.post(FDAPIConstants.addToWishList,
          data: {FDWSRecipeConstants.recipeId: recipeId});
      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final respData = resp.data;
        if (respData['msg'] != null) {
          return respData['msg'];
        } else {
          return respData['error'];
        }
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }

  Future<dynamic> removeFromWishList(int recipeId) async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);

    try {
      final resp = await dio.post(FDAPIConstants.removeFromWishList,
          data: {FDWSRecipeConstants.recipeId: recipeId});
      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final respData = resp.data;
        if (respData['msg'] != null) {
          return respData['msg'];
        } else {
          return respData['error'];
        }
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }
}
