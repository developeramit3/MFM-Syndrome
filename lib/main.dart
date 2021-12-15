import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:eclass/utils/AppValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'package:trust_location/trust_location.dart';
import 'common/global.dart';
import 'my_app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  //     );
  authToken = await storage.read(key: "token");
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'ar', 'ur', 'hi']);


  runApp(LocalizedApp(delegate, MyApp(authToken)));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}


