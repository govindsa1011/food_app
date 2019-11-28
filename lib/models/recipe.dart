import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:food_app/helper/constants.dart';

class Recipe {
  int id;
  String name;
  String preparationTime;
  String photo;
  String serves;
  String complexity;
  String firstName;
  String lastName;
  File photoFile;
  List<Ingredient> ingredient;
  List<Instruction> instruction;
  bool inWishList;

  Recipe(
      {@required this.id,
      @required this.name,
      @required this.preparationTime,
      @required this.photo,
      @required this.serves,
      @required this.complexity,
      @required this.firstName,
      @required this.lastName,
      this.inWishList = false,
      this.photoFile,
      this.ingredient,
      this.instruction});

  factory Recipe.fromJson(Map<String, dynamic> parsedJson) {
    List<Ingredient> ingrList;
    List<Instruction> instrList;

    if (parsedJson[FDWSRecipeConstants.ingredients] != null) {
      var list = parsedJson[FDWSRecipeConstants.ingredients] as List;
      ingrList = list.map((i) => Ingredient.fromJSON(i)).toList();
    }

    if (parsedJson[FDWSRecipeConstants.instructions] != null) {
      var list = parsedJson[FDWSRecipeConstants.instructions] as List;
      instrList = list.map((i) => Instruction.fromJSON(i)).toList();
    }

    return Recipe(
        complexity: parsedJson[FDWSRecipeConstants.complexity],
        firstName: parsedJson[FDWSRecipeConstants.firstName],
        id: parsedJson[FDWSRecipeConstants.recipeId],
        lastName: parsedJson[FDWSRecipeConstants.lastName],
        name: parsedJson[FDWSRecipeConstants.name],
        photo: parsedJson[FDWSRecipeConstants.photo],
        preparationTime: parsedJson[FDWSRecipeConstants.preparationTime],
        serves: parsedJson[FDWSRecipeConstants.serves],
        inWishList:
            parsedJson[FDWSRecipeConstants.inWishList] == 1 ? true : false,
        ingredient: ingrList,
        instruction: instrList);
  }
}

class Ingredient {
  int id;
  String ingredientName;

  Ingredient({this.id, this.ingredientName});

  factory Ingredient.fromJSON(Map<String, dynamic> parsedJSON) {
    return Ingredient(
        id: parsedJSON[FDWSRecipeConstants.id],
        ingredientName: parsedJSON[FDWSRecipeConstants.ingredient]);
  }
}

class Instruction {
  int id;
  String instructionText;

  Instruction({this.id, this.instructionText});

  factory Instruction.fromJSON(Map<String, dynamic> parsedJSON) {
    return Instruction(
        id: parsedJSON[FDWSRecipeConstants.id],
        instructionText: parsedJSON[FDWSRecipeConstants.instruction]);
  }
}
