import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/constants.dart';
import '../models/user.dart';

class UserInfo with ChangeNotifier {
  User _loggedInUser =
      User(email: '', firstName: '', lastName: '', password: '', id: 0);

  Future<User> get currentUser async {
    _loggedInUser = await FDUtility.getCurrentUser();
    return _loggedInUser;
  }

  _setUser(User user) async {
    _loggedInUser = user;
  }

  Future<void> makeLogin(String email, String password) async {
    try {
      final baseOptions = await FDUtility.createDioObject();
      Dio dio = new Dio(baseOptions);
      final resp = await dio.post(FDAPIConstants.login,
          data: {FDWSConstants.email: email, FDWSConstants.password: password});

      if (resp.statusCode >= 200 && resp.statusCode <= 300) {
        final userData = resp.data;
        final user = User.fromJson(userData);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(FDWSConstants.token, userData[FDWSConstants.token]);
        prefs.setString(FDWSConstants.userInfo, json.encode(user));
        _setUser(user);
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
