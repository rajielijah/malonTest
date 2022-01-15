import 'package:flutter/material.dart';
import 'package:malontest/screens/finder_screen.dart';
import 'package:malontest/utils/constants.dart';
import 'package:malontest/utils/file_manager.dart' as file;
import 'package:malontest/utils/navi.dart' as navi;
import 'package:malontest/utils/scroll_top_with_controller.dart'
    as scrollTop;
import 'package:malontest/utils/toast_alert.dart' as alert;
import 'package:malontest/widgets/bottom_navigation.dart';
import 'package:malontest/widgets/bottom_navigation_item.dart';
import 'package:malontest/widgets/custom_loading_spin_kit_ring.dart';
import 'package:malontest/widgets/custom_main_appbar_content.dart';
import 'package:malontest/widgets/movie_card.dart';
import 'package:malontest/widgets/movie_card_container.dart';
import 'package:malontest/widgets/shadowless_floating_button.dart';
import 'package:sizer/sizer.dart';
import 'package:malontest/services/movie.dart';

//Homepage that show the list of movies, search and other functionalities
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //for custom drawer opening
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //for scroll upping
  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  Color? themeColor;
  int? activeInnerPageIndex;
  List<MovieCard>? _movieCards;
  bool showSlider = true;
  String title = kHomeScreenTitleText;
  int bottomBarIndex = 1;

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    _movieCards = (bottomBarIndex == 1)
        ? await movieModel.getMovies(
            moviesType: MoviePageType.values[activeInnerPageIndex!],
            themeColor: themeColor!)
        : await movieModel.getFavorites(
            themeColor: themeColor!, bottomBarIndex: bottomBarIndex);
    setState(() {
      scrollTop.scrollToTop(_scrollController!);
      showBackToTopButton = false;
    });
  }

  //function to switch from homepage to favourite
  void pageSwitcher(int index) {
    setState(() {
      bottomBarIndex = (index == 2) ? 2 : 1;
      title = (index == 2) ? kFavoriteScreenTitleText : kHomeScreenTitleText;
      showSlider = !(index == 2);
      _movieCards = null;
      loadData();
    });
  }

//function to switch movie category from Populars to Coming soon to Top Rated
  void movieCategorySwitcher(int index) {
    setState(() {
      activeInnerPageIndex = index;
      _movieCards = null;
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      themeColor = await file.currentTheme();
      print(themeColor);
      _scrollController = ScrollController()
        ..addListener(() {
          setState(() {
            showBackToTopButton = (_scrollController!.offset >= 200);
          });
        });
      activeInnerPageIndex = 0;
      setState(() {
        loadData();
      });
    }();
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Listing of the movies, the search functionality
    return (themeColor == null)
        ? CustomLoadingSpinKitRing(loadingColor: themeColor)
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kAppBarColor,
              shadowColor: Colors.transparent,
              bottom: PreferredSize(
                child: CustomMainAppBarContent(
                  showSlider: showSlider,
                  title: title,
                  activeButtonIndex: activeInnerPageIndex!,
                  activeColor: themeColor!,
                  buttonFistOnPressed: (index) => movieCategorySwitcher(index),
                  buttonSecondOnPressed: (index) =>
                      movieCategorySwitcher(index),
                  buttonThirdOnPressed: (index) => movieCategorySwitcher(index),
                  searchOnPressed: () => navi.newScreen(
                    context: context,
                    newScreen: () => FinderScreen(
                      themeColor: themeColor!,
                    ),
                  ),
                ),
                preferredSize:
                    Size.fromHeight((bottomBarIndex == 1) ? 16.0.h : 7.h),
              ),
            ),
            body: (_movieCards == null)
                ? CustomLoadingSpinKitRing(loadingColor: themeColor)
                : (_movieCards!.length == 0)
                    ? Center(child: Text(k404Text))
                    : MovieCardContainer(
                        scrollController: _scrollController!,
                        themeColor: themeColor!,
                        movieCards: _movieCards!,
                      ),
                //Bottom Navigation that consits of the homepage and the favourite
            bottomNavigationBar: BottomNavigation(
              activeColor: themeColor!,
              index: bottomBarIndex,
              children: [
                BottomNavigationItem(
                  icon: Icon(Icons.more_horiz,),
                  iconSize: 35.sp,
                  onPressed: (){},
                ),
                BottomNavigationItem(
                  icon: Icon(Icons.videocam),
                  iconSize: 28.sp,
                  onPressed: () {
                    pageSwitcher(1);
                  },
                ),
                BottomNavigationItem(
                    icon: Icon(Icons.favorite),
                    iconSize: 23.sp,
                    onPressed: () {
                      pageSwitcher(2);
                    }),
              ],
            ),
           //Floatingaction Button that take the list up when user clicks on it
            floatingActionButton: showBackToTopButton
                ? ShadowlessFloatingButton(
                    iconData: Icons.keyboard_arrow_up_outlined,
                    onPressed: () {
                      setState(() {
                        scrollTop.scrollToTop(_scrollController!);
                      });
                    },
                    backgroundColor: themeColor,
                  )
                : null,
          );
  }
}
