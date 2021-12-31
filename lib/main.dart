import 'dart:io';
import 'package:eclass/utils/AppValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'common/global.dart';
import 'my_app.dart';
import 'dart:io' show Platform, exit;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
  }
  authToken = await storage.read(key: "token");
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'ar', 'ur', 'hi']);
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("3bf57f8e-4089-4542-a91c-aa4e6e000586");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  runApp(LocalizedApp(delegate, MyApp(authToken)));

}


