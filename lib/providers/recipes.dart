import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_app/helper/constants.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/models/user.dart';
import 'package:path/path.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _items = [];
  Recipe recipeDetails;

  List<Recipe> get items {
    return [..._items];
  }

  clearCurrentItem() {
    return recipeDetails = null;
  }

  Recipe findById(int id) {
    return _items.length > 0
        ? _items.firstWhere((item) {
            return item.id == id;
          })
        : null;
  }

  int findIndexOfRecipe(int id) {
    final currentItem = findById(id);
    if (currentItem != null) {
      return _items.indexOf(currentItem);
    } else {
      return -1;
    }
  }

  hideRecipe(int id) {
    final currentItem = findById(id);
    if (currentItem != null) {
      _items.remove(currentItem);
      notifyListeners();
    }
  }

  int userFavoriteCount() {
    if (_items.length > 0) {
      int count = 0;
      _items.forEach((recipe) {
        if (recipe.inWishList) {
          count++;
        }
      });
      return count;
    } else {
      return 0;
    }
  }

  int userCreatedRecipe(User user) {
    if (_items.length > 0) {
      int count = 0;
      _items.forEach((recipe) {
        if (recipe.firstName == user.firstName &&
            recipe.lastName == user.lastName) {
          count++;
        }
      });
      return count;
    } else {
      return 0;
    }
  }

  updateRecipeWishListStatus(int id, bool status) {
    final currentItem = findById(id);
    if (currentItem != null) {
      currentItem.inWishList = status;
      final index = findIndexOfRecipe(id);
      if (index > -1) {
        final recipe = items.removeAt(index);
        items.insert(index, recipe);
      }
    }
    notifyListeners();
  }

  Future<void> fetchRecipes() async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);
    try {
      final resp = await dio.get(FDAPIConstants.getFeed);

      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final data = resp.data;
        if (data is List<dynamic>) {
          final List<Recipe> recipeObj = [];
          data.forEach((recipe) {
            recipeObj.add(Recipe.fromJson(recipe));
          });

          _items = recipeObj;
          notifyListeners();
        }
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }

  Future<void> getRecipeDetails(int id) async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);
    // dio.interceptors.add(LogInterceptor(responseBody: true));
    try {
      final resp =
          await dio.get(FDAPIConstants.recipeDetails.replaceFirst('##', '$id'));
      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final data = resp.data;
        if (data is Map<String, dynamic>) {
          recipeDetails = Recipe.fromJson(data);
        } else {
          throw (CommonMessage.InvalidData);
        }
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }

  Future<dynamic> addRecipe(Recipe recipe) async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);

    try {
      final resp = await dio.post(FDAPIConstants.addRecipe, data: {
        FDWSRecipeConstants.name: recipe.name,
        FDWSRecipeConstants.preparationTime: recipe.preparationTime,
        FDWSRecipeConstants.complexity: recipe.complexity,
        FDWSRecipeConstants.serves: recipe.serves
      });

      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final recipeData = resp.data;
        final recipeId = recipeData[FDWSRecipeConstants.id];
        recipe.id = recipeId;
        if (recipe.photo != null) {
          await updateImage(recipe.photoFile, recipeId).then((imagePath) {
            recipe.photo = imagePath;
          }).catchError((err) {});
        }
        _items.add(recipe);
        notifyListeners();
        return recipeId;
        // print(recipeData);
      } else {
        print('Status other than 200');
        throw (CommonMessage.errorGenericMessage);
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }

  Future<dynamic> updateImage(File image, int recipeId) async {
    final baseOptions = await FDUtility.createDioObject();
    final dio = Dio(baseOptions);

    // dio.interceptors.add(LogInterceptor(responseBody: true));
    try {
      FormData formdata = new FormData();
      formdata.add(
          FDWSRecipeConstants.photo,
          new UploadFileInfo(image, basename(image.path),
              contentType: ContentType.parse('image/png')));
      formdata.add(FDWSRecipeConstants.recipeId, recipeId);

      final resp =
          await dio.post(FDAPIConstants.updateRecipePhoto, data: formdata);

      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final recipeData = resp.data;
        return recipeData[FDWSRecipeConstants.photo];
      } else {
        print('Status other than 200');
        throw (CommonMessage.errorGenericMessage);
      }
    } on DioError catch (e) {
      FDUtility.apiErrorHandler(e);
    } catch (e) {
      print(e);
      throw (CommonMessage.errorGenericMessage);
    }
  }
}
