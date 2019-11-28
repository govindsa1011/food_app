import 'package:flutter/material.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/providers/recipes.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/widget/skeleton_structure.dart';
import 'package:provider/provider.dart';

class RecipeInfoScreen extends StatefulWidget {
  var currentItem;

  RecipeInfoScreen(this.currentItem);

  @override
  _RecipeInfoScreenState createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen>
    with TickerProviderStateMixin {
  var infoHeight;
  AnimationController animationController;
  Animation<double> animation;
  Recipe recipe;
  List<Widget> mChipList = new List();
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  var _isInit = true;
  var isLoading = false;

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
      Provider.of<Recipes>(context).clearCurrentItem();
      Provider.of<Recipes>(context)
          .getRecipeDetails(widget.currentItem['id'])
          .then((_) {
        setState(() {
          isLoading = false;
        });
        recipe = Provider.of<Recipes>(context).recipeDetails;
        mChipList.clear();
        for (var i = 0; i < recipe.ingredient.length; i++) {
          var chip = new Chip(label: Text(recipe.ingredient[i].ingredientName));
          mChipList.add(chip);
        }

        setData();
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
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: recipe.photo != null
                                ? Stack(
                                    children: [
                                      FadeInImage.assetNetwork(
                                          image: recipe.photo,
                                          fit: BoxFit.fill,
                                          placeholder:
                                              'images/placeholder_image.png')
                                    ],
                                  )
                                : Image.asset(
                                    'images/placeholder_image.png',
                                    fit: BoxFit.fill,
                                  )),
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
                                    recipe.name,
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
                                        getTimeBoxUI(recipe.preparationTime,
                                            Icons.access_time),
                                        getTimeBoxUI(
                                            recipe.complexity, Icons.ac_unit),
                                        getTimeBoxUI(
                                            recipe.serves, Icons.group),
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
                                            "Ingredients",
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
                    top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                    right: 35,
                    child: new ScaleTransition(
                      alignment: Alignment.center,
                      scale: new CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn),
                      child: Card(
                        color: recipe.inWishList
                            ? Colors.red
                            : AppTheme.nearlyBlack,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 10.0,
                        child: Container(
                          width: 60,
                          height: 60,
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: AppTheme.nearlyWhite,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
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
                            Icons.arrow_back_ios,
                            color: AppTheme.nearlyWhite,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget getTimeBoxUI(String text1, IconData iconData) {
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
                Icon(
                  iconData,
                  color: AppTheme.nearlyBlack,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
