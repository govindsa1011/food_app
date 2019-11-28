import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/helper/route_generator.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/ui/favroite.dart';
import 'package:food_app/ui/home.dart';
import 'package:food_app/ui/profile.dart';
import 'package:food_app/ui/search.dart';
import 'package:food_app/widget/bottomNavigationView/bottomBarView.dart';
import 'package:food_app/widget/bottomNavigationView/models/tabIconData.dart';

class DashBoard_Screen extends StatefulWidget {
  @override
  _DashBoard_Screen_State createState() => _DashBoard_Screen_State();
}

class _DashBoard_Screen_State extends State<DashBoard_Screen>
    with TickerProviderStateMixin {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  AnimationController animationController;

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    tabBody = HomeScreen(animController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget tabBody = Container(
    color: Colors.transparent,
  );

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            Navigator.of(context).pushNamed(RouteGenerator.addNewRoute);
          },
          changeIndex: (index) {
            if (index == 0) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = HomeScreen(animController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = SearchScreen(animController: animationController);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody = FavoriteScreen(animController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  tabBody =
                      ProfileScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
