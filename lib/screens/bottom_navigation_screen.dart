import 'dart:async';
import 'dart:io';
import 'package:eclass/localization/language_provider.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import 'package:eclass/provider/watchlist_provider.dart';
import 'package:eclass/utils/AppValidation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_screen.dart';
import 'courses_screen.dart';
import 'settings_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/custom_drawer.dart';
import '../common/theme.dart' as T;
import '../provider/bundle_course.dart';
import '../provider/courses_provider.dart';
import '../provider/user_profile.dart';
import '../provider/visible_provider.dart';
import '../utils/custom-icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'all_category_screen.dart';
import 'home_screen.dart';
import 'dart:io' show Platform;

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});

  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex;
  int isShowingDialog=0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CoursesScreen(),
    AllCategoryScreen(),
    CartScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getHomePageData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CoursesProvider coursesProvider =
          Provider.of<CoursesProvider>(context, listen: false);
      RecentCourseProvider recentCourseProvider =
          Provider.of<RecentCourseProvider>(context, listen: false);
      BundleCourseProvider bundleCourseProvider =
          Provider.of<BundleCourseProvider>(context, listen: false);
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      Visible visiblePro = Provider.of<Visible>(context, listen: false);
      await coursesProvider.getAllCourse(context);
      await recentCourseProvider.fetchRecentCourse(context);
      await coursesProvider.initPurchasedCourses(context);
      await bundleCourseProvider.getbundles();
      await userProfile.fetchUserProfile();

      await Provider.of<WatchlistProvider>(context, listen: false)
          .removeFromWatchList();

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      if (sharedPreferences.containsKey("giftUserId")) {
        await sharedPreferences.remove("giftUserId");
        await sharedPreferences.remove("giftCourseId");
      }

      Timer(Duration(milliseconds: 100), () {
        visiblePro.toggleVisible(true);
      });
    });
  }

  LanguageProvider languageProvider;

  void initState() {
    super.initState();
    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getHomePageData();
    });
    WidgetsFlutterBinding.ensureInitialized().addTimingsCallback((timings) {
     callbackDispatcher();
    });
    final newVersion = NewVersion(
      iOSId: 'tech.phoenixtechs.mfmsyndrome',
      androidId: 'tech.phoenixtechs.mfmsyndrome',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = false;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }
  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'New version available',
        dialogText: 'Please updae app for best performance.',
      );
    }
  }
  showErrorDialog(BuildContext context,String message) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
        title: Text(
          'Warning',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            message,
            style: TextStyle(fontFamily: 'Mada', color: Color(0xFF3F4654)),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                isShowingDialog=0;
                Navigator.pop(context);
              },
              child: Text(
                "Done".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF153CFC), fontWeight: FontWeight.w600),
              )),
          FlatButton(
              onPressed: () {
                exit(0);
              },
              child: Text(
                "Exit".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );

  }
  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(
          translate("Confirm_Exit"),
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          translate("Are_you_sure_that_you_want_to_exit"),
          style: TextStyle(fontFamily: 'Mada', color: Color(0xFF3F4654)),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                translate("Cancel_").toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
          SizedBox(height: 16),
          FlatButton(
              onPressed: () {
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: Text(
                translate("Yes_").toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
    return new Future.value(value);
  }

  Widget navigationBar() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, -10.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: BottomNavigationBar(
        elevation: 1.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: const Color(0xFF3F4654)),
        unselectedIconTheme: IconThemeData(color: const Color(0xFFC9D4E2)),
        selectedItemColor: const Color(0xFF3F4654),
        unselectedItemColor: const Color(0xFFC9D4E2),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.home),
            label: translate("Home_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.home,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.home_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.courses),
            label: translate("Courses_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.courses,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.courses_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.categories),
            label: translate("Categories_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.categories,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.categories_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.cart),
            label: translate("Cart_"),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.cart,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.cart_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.settings),
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.settings,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.settings_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
            label: translate("Settings_"),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedLabelStyle: TextStyle(color: Colors.white),
        onTap: _onItemTapped,
      ),
    );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return WillPopScope(
        child: Scaffold(
            key: scaffoldKey,
            appBar: appBar(mode.bgcolor, context, scaffoldKey),
            drawer: CustomDrawer(),
            bottomNavigationBar: navigationBar(),
            body: Center(child: _widgetOptions.elementAt(_selectedIndex))),
        onWillPop: onBackPressed);
  }
}
