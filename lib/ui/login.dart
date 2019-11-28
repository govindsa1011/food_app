import 'package:flutter/material.dart';
import 'package:food_app/widget/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../helper/fdutility.dart';
import '../helper/route_generator.dart';
import '../providers/userInfo.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/logo.png', height: 100, width: 100),
                Text(
                  "Foodie Login",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                LoginForm()
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String email = "";
  String password = "";

  @override
  void initState() {
    setState(() {
      _passwordVisible = _passwordVisible;
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _makeLogin() async {
    ProgressUtils.showLoading(context);

    Provider.of<UserInfo>(context).makeLogin(email, password).then((_) {
      ProgressUtils.hideLoading(context);
      Navigator.of(context).pushReplacementNamed(RouteGenerator.homeRoute);
    }).catchError((err) {
      FDUtility.updateUserWithResponse(context, err);
    });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Container(
          padding: const EdgeInsets.all(25),
          child: new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(top: 20)),
                new TextFormField(
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    onSaved: (value) => email = value.trim(),
                    decoration: new InputDecoration(
                      labelText: "Enter Email",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Email cannot be empty";
                      } else if (validateEmail(val) != null) {
                        return validateEmail(val);
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress),
                new Padding(padding: EdgeInsets.only(top: 20)),
                new TextFormField(
                    focusNode: _passwordFocusNode,
                    onSaved: (value) => password = value.trim(),
                    decoration: new InputDecoration(
                        labelText: "Enter Password",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )
                        //fillColor: Colors.green
                        ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Password cannot be empty";
                      } else if (val.length < 6 || val.length > 15) {
                        return "Password length should be 6 to 15";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    obscureText: _passwordVisible),
                new Padding(padding: EdgeInsets.only(top: 20)),
                new FlatButton(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Login'),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _emailFocusNode.unfocus();
                      _passwordFocusNode.unfocus();

                      _formKey.currentState.save();

                      _makeLogin();
                    }
                  },
                ),
                new Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  "Forgot password?",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }
}
