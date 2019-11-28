import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/helper/route_generator.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/providers/recipes.dart';
import 'package:food_app/ui/appTheme.dart';
import 'package:food_app/widget/empty_list.dart';
import 'package:food_app/widget/recipe_list_item.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final AnimationController animController;

  const SearchScreen({Key key, this.animController}) : super(key: key);

  @override
  _Search_Screen_State createState() => _Search_Screen_State();
}

class _Search_Screen_State extends State<SearchScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<Recipe> mDataList, recipesData;
  ScrollController _scrollController = new ScrollController();
  final queryController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    setState(() {
      mDataList = List();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    recipesData = Provider.of<Recipes>(context).items;

    return Container(
        color: AppTheme.background,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "Search",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: NestedScrollView(
                          controller: _scrollController,
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[getSearchBarUI()],
                                  );
                                }, childCount: 1),
                              )
                            ];
                          },
                          body: getListUI(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: queryController,
                    onChanged: (String txt) {
                      setState(() {
                        if (txt.trim().length == 0) {
                          mDataList = List();
                        }
                      });
                    },
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Pizza...",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    if (queryController.text.trim().length > 0) {
                      mDataList = recipesData
                          .where((recipe) => recipe.name.toLowerCase().contains(
                              queryController.text.trim().toLowerCase()))
                          .toList();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20, color: AppTheme.background),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getListUI() {
    return mDataList.length > 0
        ? Container(
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

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget searchUI;

  ContestTabHeader(
    this.searchUI,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
