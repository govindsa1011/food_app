class FDAPIConstants {
  static const baseUrl = 'http://35.160.197.175:3006/api/';
  static const version = 'v1/';

  static const login = 'user/login';

  static const getFeed = 'recipe/feeds';
  static const recipeDetails = 'recipe/##/details';
  static const addRecipe = 'recipe/add';
  static const updateRecipePhoto = 'recipe/add-update-recipe-photo';
  static const addIngredient = 'recipe/add-ingredient';
  static const addInstruction = 'recipe/add-instruction';

  static const getWishList = 'recipe/cooking-list';
  static const addToWishList = 'recipe/add-to-cooking-list';
  static const removeFromWishList = 'recipe/rm-from-cooking-list';
}

class FDWSConstants {
  static const email = 'email';
  static const password = 'password';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const id = 'id';
  static const token = 'token';
  static const userInfo = 'userInfo';
}

class FDWSRecipeConstants {
  static const name = 'name';
  static const id = 'id';
  static const preparationTime = 'preparationTime';
  static const photo = 'photo';
  static const serves = 'serves';
  static const complexity = 'complexity';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const ingredient = 'ingredient';
  static const instruction = 'instruction';
  static const ingredients = 'ingredients';
  static const instructions = 'instructions';
  static const recipeId = 'recipeId';
  static const inWishList = 'inCookingList';
}

class CommonMessage {
  static const errorGenericMessage = 'something went wrong';
  static const InvalidData = 'Invalid Data, Please try other recipe';
}
