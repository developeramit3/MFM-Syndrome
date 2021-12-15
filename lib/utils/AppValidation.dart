import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
import 'dart:io' show Platform;
Future<String> checkViolence() async {
  StringBuffer messagess=StringBuffer();
   const platform = const MethodChannel('flutter.native/helper');
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
  }if(Platform.isAndroid){
    isDevMode = await  platform.invokeMethod('isDevMode');
  }if(Platform.isAndroid){
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
  bool isAllFine= !isJailBroken&&isRealDevice&&!canMockLocation&&!isOnExternalStorage&&!isBla&&!isHotSpotEnabled&&!isDevMode&&!isUSBConnected;
  return messagess.toString();
}
void backgroundFetchHeadlessTask(task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    checkViolence().then((value) =>{
      print("Running ==== $value")
    });
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}