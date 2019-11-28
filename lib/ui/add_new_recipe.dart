import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:image_picker/image_picker.dart';

class AddNewRecipe extends StatefulWidget {
  @override
  _AddNewRecipe createState() => _AddNewRecipe();
}

class _AddNewRecipe extends State<AddNewRecipe> with TickerProviderStateMixin {
  var infoHeight;
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  File imageFile;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));

    setData();

    super.initState();
  }

  void setData() async {
    animationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    infoHeight = MediaQuery.of(context).size.height - 250;
    final tempHight = (MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0);

    return Scaffold(
        backgroundColor: AppTheme.background,
        body: Container(
          color: AppTheme.nearlyWhite,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: imageFile == null
                          ? Image.asset(
                              'images/placeholder_image.png',
                              fit: BoxFit.fill,
                            )
                          : Image.file(imageFile, fit: BoxFit.fill),
                    ),
                  ],
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.nearlyWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: infoHeight,
                              maxHeight: tempHight > infoHeight
                                  ? tempHight
                                  : infoHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: opacity1,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: <Widget>[
                                      new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 35)),
                                      TextFormField(
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) {},
                                          decoration: new InputDecoration(
                                            labelText: "Recipe Name",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType: TextInputType.text),
                                      new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20)),
                                      TextFormField(
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) {},
                                          decoration: new InputDecoration(
                                            labelText: "Prepration Time",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType: TextInputType.text),
                                      new Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20)),
                                      TextFormField(
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) {},
                                          decoration: new InputDecoration(
                                            labelText: "Serves",
                                            fillColor: Colors.white,
                                            border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType: TextInputType.number)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: opacity2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                  right: 35,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: new CurvedAnimation(
                        parent: animationController,
                        curve: Curves.fastOutSlowIn),
                    child: InkWell(
                      child: Card(
                        color: AppTheme.nearlyBlack,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Icon(
                              Icons.save,
                              color: AppTheme.nearlyWhite,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        log("Clicked");
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: SizedBox(
                      width: AppBar().preferredSize.height,
                      height: AppBar().preferredSize.height,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: new BorderRadius.circular(
                              AppBar().preferredSize.height),
                          child: Icon(
                            Icons.add_a_photo,
                            color: AppTheme.nearlyWhite,
                          ),
                          onTap: () {
                            _optionsDialogBox();
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openCamera() async {
    Navigator.pop(context);
    // using your method of getting an image
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = image;
    });
  }

  Future openGallery() async {
    Navigator.pop(context);
    // using your method of getting an image
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      imageFile = image;
    });
  }
}
