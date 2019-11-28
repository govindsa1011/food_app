import 'package:flutter/material.dart';
import 'package:food_app/helper/route_generator.dart';
import 'package:food_app/providers/wishlist.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/widget/empty_list.dart';
import 'package:food_app/widget/recipe_list_item.dart';
import 'package:food_app/widget/skeleton_structure.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  final AnimationController animController;

  const FavoriteScreen({Key key, this.animController}) : super(key: key);

  @override
  _Favorite_Screen_State createState() => _Favorite_Screen_State();
}

class _Favorite_Screen_State extends State<FavoriteScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  var _isInit = true;
  var isLoading = false;
  var mDataList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<WishList>(context).fetchWishList().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipesData = Provider.of<WishList>(context);
    mDataList = recipesData.favoriteRecipes;

    return isLoading
        ? FDSkeletonView()
        : Container(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  "Favorites",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: AppTheme.background,
              ),
              body: Stack(
                children: <Widget>[
                  InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: getListUI())
                ],
              ),
            ),
          );
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget getListUI() {
    return mDataList.length > 0
        ? Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 140,
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      } else {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: mDataList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var count =
                                mDataList.length > 10 ? 10 : mDataList.length;
                            var animation = Tween(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController.forward();

                            return RecipeItemView(
                              callback: () {
                                Navigator.of(context).pushNamed(
                                    RouteGenerator.detailRoute,
                                    arguments: {'id': mDataList[index].id});
                              },
                              isFromHome: false,
                              recipeData: mDataList[index],
                              animation: animation,
                              animationController: animationController,
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )
        : FDEmptyList(
            message: "No recipes found",
          );
  }
}
