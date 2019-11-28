import 'package:flutter/material.dart';
import 'package:food_app/helper/fdutility.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/providers/recipes.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/widget/alert_dialog.dart';
import 'package:food_app/widget/skeleton_structure.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final AnimationController animationController;

  const ProfileScreen({Key key, this.animationController}) : super(key: key);

  @override
  _Profile_Screen_State createState() => _Profile_Screen_State();
}

class _Profile_Screen_State extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var infoHeight;
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  User user;
  int fav, created;
  var _isInit = true;
  var isLoading = false;
  List<Widget> mChipList = List();

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });

      FDUtility.getCurrentUser().then((value) {
        if (value != null) {
          user = value;
          fav = Provider.of<Recipes>(context).userFavoriteCount();
          created = Provider.of<Recipes>(context).userCreatedRecipe(user);

          mChipList.clear();
          mChipList.add(Chip(label: Text("Mexican")));
          mChipList.add(Chip(label: Text("Punjabi")));
          mChipList.add(Chip(label: Text("South India")));
          mChipList.add(Chip(label: Text("Italian")));
          mChipList.add(Chip(label: Text("Gujarati")));
          mChipList.add(Chip(label: Text("Chinese")));

          setState(() {
            isLoading = false;
          });
          setData();
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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

    return isLoading
        ? FDDetailsSkeletonView()
        : Container(
            color: AppTheme.nearlyWhite,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.asset(
                          'images/bg.jpg',
                          fit: BoxFit.fill,
                        ),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 32.0, left: 18, right: 16),
                                  child: Text(
                                    user.firstName + " " + user.lastName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: opacity1,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        getTimeBoxUI("Favorite Recipes", '$fav',
                                            Icons.favorite),
                                        getTimeBoxUI("Created Recipes",
                                            '$created', Icons.fastfood),
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
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Favorite Cusines",
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.27,
                                              color: AppTheme.nearlyBlack,
                                            ),
                                            overflow: TextOverflow.fade,
                                          ),
                                          mChipList.length > 0
                                              ? Wrap(
                                                  spacing: 8.0,
                                                  // gap between adjacent chips
                                                  runSpacing: 4.0,
                                                  // gap between lines
                                                  children: mChipList,
                                                )
                                              : Text(
                                                  "No Any Ingredients",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: AppTheme.nearlyBlack,
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                )
                                        ],
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
                    top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 50,
                    right: 35,
                    child: new ScaleTransition(
                      alignment: Alignment.center,
                      scale: new CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: Container(
                          child: Image.asset("images/avatar.png",
                              fit: BoxFit.fill, width: 100, height: 100),
                        ),
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
                              Icons.exit_to_app,
                              color: AppTheme.nearlyWhite,
                            ),
                            onTap: () {
                              FDAlertDialog.showConfirmation(
                                  context, "Are you sure want to log out?");
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

Widget getTimeBoxUI(String text1, String text2, IconData iconData) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: AppTheme.nearlyBlack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.27,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                  ),
                  Icon(
                    iconData,
                    color: AppTheme.nearlyBlack,
                    size: 20,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
