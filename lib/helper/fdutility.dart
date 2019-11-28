import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/widget/alert_dialog.dart';
import 'package:food_app/widget/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class FDUtility {
  static Future<BaseOptions> createDioObject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(FDWSConstants.token);

    return BaseOptions(
        baseUrl: '${FDAPIConstants.baseUrl}${FDAPIConstants.version}',
        headers: token != null ? {'Authorization': 'Bearer $token'} : null);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(FDWSConstants.token);
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfo = prefs.getString(FDWSConstants.userInfo);
    Map<String, dynamic> userObj = jsonDecode(userInfo);
    return User.fromJson(userObj);
  }

  static clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(FDWSConstants.token);
  }

  static updateUserWithResponse(BuildContext context, String message) {
    ProgressUtils.hideLoading(context);
    FDAlertDialog.showAlert(context, message);
  }

  static apiErrorHandler(DioError e) {
    if (e.response != null) {
      print(e.response.data);
      if (e.response.data is Map<String, dynamic>) {
        throw (e.response.data['error']);
      } else {
        throw (CommonMessage.errorGenericMessage);
      }
    } else {
      print(e.message);
      throw (e.message);
    }
  }
}
