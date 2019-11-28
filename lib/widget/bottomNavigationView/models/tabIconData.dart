import 'package:flutter/material.dart';

class TabIconData {
  String imagePath;
  String selctedImagePath;
  bool isSelected;
  int index;
  AnimationController animationController;

  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selctedImagePath = "",
    this.isSelected = false,
    this.animationController,
  });

  static List<TabIconData> tabIconsList = [
    TabIconData(
      imagePath: 'images/home.png',
      selctedImagePath: 'images/home_s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/search.png',
      selctedImagePath: 'images/search_s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/like.png',
      selctedImagePath: 'images/like_s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'images/user.png',
      selctedImagePath: 'images/user_s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
