import 'package:background_fetch/background_fetch.dart';
import 'package:eclass/Screens/blog_list_screen.dart';
import 'package:eclass/Screens/terms_policy.dart';
import 'package:eclass/localization/language_screen.dart';
import 'package:eclass/player/offline/downloads_screen.dart';
import 'package:eclass/provider/blog_provider.dart';
import 'package:eclass/localization/language_provider.dart';
import 'package:eclass/provider/manual_payment_provider.dart';
import 'package:eclass/provider/terms_policy_provider.dart';
import 'package:eclass/provider/watchlist_provider.dart';
import 'package:eclass/screens/bottom_navigation_screen.dart';
import 'package:eclass/screens/voilatws_screen.dart';
import 'package:eclass/services/http_services.dart';
import 'package:eclass/utils/AppValidation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:trust_location/trust_location.dart';

import 'gateways/donate.dart';
import 'provider/cart_provider.dart';
import 'provider/content_provider.dart';
import 'provider/course_details_provider.dart';
import 'provider/recent_course_provider.dart';
import 'Screens/faq_screen.dart';
import 'Screens/instructor_faq_screen.dart';
import 'Screens/loading_screen.dart';
import 'Screens/about_us_screen.dart';
import 'Screens/became_instructor_screen.dart';
import 'Screens/bundle_detail_screen.dart';
import 'Screens/category_screen.dart';
import 'Screens/child_category_screen.dart';
import 'Screens/contact_us_screen.dart';
import 'Screens/course_details_screen.dart';
import 'Screens/course_instructor_screen.dart';
import 'Screens/courses_screen.dart';
import 'Screens/edit_profile.dart';
import 'Screens/filter_screen.dart';
import 'Screens/forgot_password.dart';
import 'Screens/home_screen.dart';
import 'Screens/sign_in_screen.dart';
import 'Screens/notification_detail_screen.dart';
import 'Screens/notifications_screen.dart';
import 'Screens/purchase_history_screen.dart';
import 'Screens/sign_up_screen.dart';
import 'Screens/sub_category_screen.dart';
import 'provider/bundle_course.dart';
import 'provider/cart_pro_api.dart';
import 'provider/filter_pro.dart';
import 'provider/home_data_provider.dart';
import 'provider/payment_api_provider.dart';
import 'provider/visible_provider.dart';
import 'provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/courses_provider.dart';
import 'provider/user_details_provider.dart';
import 'common/theme.dart' as T;
import 'provider/user_profile.dart';
import 'dart:io' show Platform;

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String token;
  bool isJailBroken=false;
  bool isRealDevice=false;
  bool canMockLocation=false;
  bool isOnExternalStorage=false;
  bool isBla=false;
  bool isDevMode = false;
  bool isHotSpotEnabled = false;
  static const platform = const MethodChannel('flutter.native/helper');
  final HttpService httpService = HttpService();
  MyApp(this.token){
    configBackgroundTask();
  }
  // This widget is the root of your application.

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);


  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()), // Fetch User Details
        ChangeNotifierProvider(create: (_) => T.Theme()), // Theme Data
        ChangeNotifierProvider(create: (_) => UserProfile()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => CartProducts()),
        ChangeNotifierProvider(create: (_) => FilterDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BundleCourseProvider()),
        ChangeNotifierProvider(create: (_) => HomeDataProvider()),
        ChangeNotifierProvider(create: (_) => Visible()),
        ChangeNotifierProvider(create: (_) => RecentCourseProvider()),
        ChangeNotifierProvider(create: (_) => PaymentAPIProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => CourseDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => TermsPolicyProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => ManualPaymentProvider()),
      ],
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          navigatorObservers: <NavigatorObserver>[observer],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,

          home: FutureBuilder(
            future: checkViolence(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                if (snapshot.data.toString().isEmpty) {
                  return FutureBuilder(
                    future: httpService.fakeLoginAPI(context),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data){
                          return MyBottomNavigationBar(
                           pageInd: 0,
                         );
                        }else{
                          return token == null ? SignInScreen() : LoadingScreen(token);
                        }
                      }else{
                        return token == null ? SignInScreen() : LoadingScreen(token);
                      }
                     },
                  );
                 } else {
                  return voilatwsScreen();
                }
              }else{
                return Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  );
              }
            },
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Mada'),
          routes: {
            '/SignIn': (context) => SignInScreen(),
            '/courseDetails': (context) => CourseDetailScreen(),
            '/InstructorScreen': (context) => CourseInstructorScreen(),
            '/homeScreen': (context) => HomeScreen(),
            '/CoursesScreen': (context) => CoursesScreen(),
            '/signUp': (context) => SignUpScreen(),
            '/category': (context) => CategoryScreen(),
            '/subCategory': (context) => SubCategoryScreen(),
            '/childCategory': (context) => ChildCategoryScreen(),
            '/forgotPassword': (context) => ForgotPassword(),
            '/editProfile': (context) => EditProfile(),
            "/bundleCourseDetail": (context) => BundleDetailScreen(),
            "/filterScreen": (context) => FilterScreen(),
            '/notifications': (context) => NotificationScreen(),
            '/becameInstructor': (context) => BecomeInstructor(),
            '/aboutUs': (context) => AboutUsScreen(),
            '/purchaseHistory': (context) => PurchaseHistoryScreen(),
            '/contactUs': (context) => ContactUsScreen(),
            '/notificationDetail': (context) => NotificationDetail(),
            '/userFaq': (context) => FaqScreen(),
            '/instructorFaq': (context) => InstructorFaqScreen(),
            '/blogList': (context) => BlogListScreen(),
            '/languageScreen': (context) => LanguageScreen(),
            '/termsPolicy': (context) => TermsPolicy(),
            '/donate': (context) => Donate(),
            '/downloads': (context) => DownloadsScreen(),
          },
        ),
      ),
    );
  }
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Waiting In ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<void> configBackgroundTask() async {
    // Configure BackgroundFetch.
    try {
      var status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        /*
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,

         */
      ), _onBackgroundFetch);
      print('[BackgroundFetch] configure success: $status');
      // Schedule a "one-shot" custom-task in 10000ms.
      // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
      // where device must be powered (and delay will be throttled by the OS).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 1000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true
      ));
    } on Exception catch(e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }
  }
  void _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch]======>: $taskId");

  }
}
