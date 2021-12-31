import 'dart:async';

import 'package:eclass/utils/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'dart:io' show Platform, exit;

const platform = const MethodChannel('flutter.native/helper');

Future<String> checkViolence() async {
  StringBuffer messagess=StringBuffer();
  bool canMockLocation=false;
  bool isOnExternalStorage=false;
  bool isBla=false;
  bool isHotSpotEnabled=false;
  bool isDevMode=false;
  bool isUSBConnected=false;
 bool isJailBroken = await SafeDevice.isJailBroken;
 bool isRealDevice = await SafeDevice.isRealDevice;
  var status = await Permission.location.status;
  if (status.isGranted) {
    canMockLocation = await SafeDevice.canMockLocation;
  }
  var statusRead = await Permission.manageExternalStorage.status;
  if (statusRead.isGranted) {
    isOnExternalStorage = await SafeDevice.isOnExternalStorage;
  }
  var statusBla = await Permission.bluetooth.status;
  if(statusBla.isGranted){
    isBla= await FlutterBlue.instance.isOn;
  }
  if(Platform.isAndroid){
    isHotSpotEnabled= await  platform.invokeMethod('isHotspotOn');
  }
  if(Platform.isAndroid){
    isDevMode = await  platform.invokeMethod('isDevMode');
  }
  if(Platform.isAndroid){
    isUSBConnected = await  platform.invokeMethod('isUSBConnected');
  }
   if(isJailBroken){
     messagess.writeln("* This device is JailBroken.");
  }
  if(canMockLocation){
  messagess.writeln(
  "* This device use mock location, Turn off mock location for running safe & open app again.");
  }
  if(!isRealDevice){
  messagess.writeln(
  "* This device is Emulator, Run in real device.");
  }
  if(isOnExternalStorage){
  messagess.writeln(
  "* This app in on External Storage, Unable to run.");
  }
  if(isBla){
  messagess.writeln(
  "* Bluetooth Is On, Turn off bluetooth for running safe & open app again.");
  }
  if(isHotSpotEnabled){
  messagess.writeln(
  "* Hotspot Is On, Turn off Hotspot for running safe & open app again.");
  }
  if(isDevMode){
  messagess.writeln(
  "* Developer option Is On, Turn off Developer option for running safe & open app again.");
  }
  if(isUSBConnected){
  messagess.writeln(
  "* USB Connected, Disconnect USD for running safe & open app again.");
  }
  // return "";
  return messagess.toString();
}
bool isShowingDialog=false;
void callbackDispatcher() {
  if(!isShowingDialog){
    checkViolence().then((value) => {
      if(value.isNotEmpty){
        isShowingDialog=true,
        showErrorDialog(value),
      }else{
        isShowingDialog=true,
        Timer(Duration(milliseconds: 10000), () {
          isShowingDialog=false;
  }),
      }
    });
  }
}
showErrorDialog(String message) {
  showDialog(
    context: NavigationService.navigatorKey.currentContext,
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
              isShowingDialog=false;
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