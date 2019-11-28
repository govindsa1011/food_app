import 'package:flutter/foundation.dart';
import 'package:food_app/helper/constants.dart';

class User {
  String firstName;
  String lastName;
  String email;
  String password;
  int id;

  User(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.password,
      @required this.id});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson[FDWSConstants.email],
        firstName: parsedJson[FDWSConstants.firstName],
        lastName: parsedJson[FDWSConstants.lastName],
        id: parsedJson[FDWSConstants.id],
        password: null);
  }

  Map<String, dynamic> toJson() => {
        FDWSConstants.firstName: firstName,
        FDWSConstants.lastName: lastName,
        FDWSConstants.id: id,
        FDWSConstants.email: email,
      };
}
