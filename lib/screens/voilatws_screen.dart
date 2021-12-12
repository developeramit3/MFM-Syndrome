import 'dart:async';
import 'dart:convert';

import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/localization/language_provider.dart';
import 'package:eclass/utils/AppValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safe_device/safe_device.dart';

import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/home_data_provider.dart';
import '../provider/user_details_provider.dart';
import '../services/http_services.dart';
import 'bottom_navigation_screen.dart';
import 'dart:io' show Platform, exit;


class voilatwsScreen extends StatefulWidget {

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<voilatwsScreen>
    with TickerProviderStateMixin {
  bool isJailBroken=true;
  bool isRealDevice=false;
  bool canMockLocation=false;
  bool isOnExternalStorage=false;
  bool isBla=false;
  bool isDevMode = false;
  bool isHotSpotEnabled = false;
  bool isUSBConnected = false;
  static const platform = const MethodChannel('flutter.native/helper');
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> initState() {
       checkViolence().then((value)=>{
         showErrorDialog(context, value),
       });

  super.initState();
  }
  showErrorDialog(BuildContext context,String message) {
    showDialog(
      context: context,
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


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var homeData = Provider.of<HomeDataProvider>(context);
    return WillPopScope(
        child: Scaffold(
         ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
        title: Text(
          'Confirm Exit',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          'Are you sure that you want to exit',
          style: TextStyle(fontFamily: 'Mada', color: Color(0xFF3F4654)),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
          FlatButton(
              onPressed: () {
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: Text(
                "Yes".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
    return new Future.value(value);
  }
}
