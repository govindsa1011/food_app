import 'dart:async';

import 'package:flutter/material.dart';

class ProgressUtils {
  static void showLoading(context) {
    List<Color> colors = [
      Colors.red,
      Colors.black,
      Colors.green,
      Colors.indigo,
      Colors.blue
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {},
            child: Dialog(
                child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ColorLoader(
                              colors: colors,
                              duration: Duration(milliseconds: 500)),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Please wait...')
                        ]))));
      },
    );
  }

  static void hideLoading(context) {
    Navigator.pop(context);
  }
}

class ColorLoader extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;

  ColorLoader({this.colors, this.duration});

  @override
  _ColorLoaderState createState() =>
      _ColorLoaderState(this.colors, this.duration);
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  final List<Color> colors;
  final Duration duration;
  Timer timer;

  _ColorLoaderState(this.colors, this.duration);

  List<ColorTween> tweenAnimations = [];
  int tweenIndex = 0;

  AnimationController controller;
  List<Animation<Color>> colorAnimations = [];

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
      vsync: this,
      duration: duration,
    );

    for (int i = 0; i < colors.length - 1; i++) {
      tweenAnimations.add(ColorTween(begin: colors[i], end: colors[i + 1]));
    }

    tweenAnimations
        .add(ColorTween(begin: colors[colors.length - 1], end: colors[0]));

    for (int i = 0; i < colors.length; i++) {
      Animation<Color> animation = tweenAnimations[i].animate(CurvedAnimation(
          parent: controller,
          curve: Interval((1 / colors.length) * (i + 1) - 0.05,
              (1 / colors.length) * (i + 1),
              curve: Curves.linear)));

      colorAnimations.add(animation);
    }

    print(colorAnimations.length);

    tweenIndex = 0;

    timer = Timer.periodic(duration, (Timer t) {
      setState(() {
        tweenIndex = (tweenIndex + 1) % colors.length;
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5.0,
          valueColor: colorAnimations[tweenIndex],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }
}
