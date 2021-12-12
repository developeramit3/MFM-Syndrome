import 'dart:convert';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/watchlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistProvider extends ChangeNotifier {
  WatchlistModel watchlistModel;

  Future<void> loadData() async {
    String url = APIData.getAllWatchlist + APIData.secretKey;

    http.Response response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (response.statusCode == 200) {
      String data = response.body;
      print('Watchlist Response :-> $data');
      watchlistModel = WatchlistModel.fromJson(await jsonDecode(data));
    } else {
      print('Watchlist Response Code :-> ${response.statusCode}');
    }
  }

  Future<void> addToWatchList({int courseId}) async {
    String url = APIData.addToWatchlist + APIData.secretKey;

    http.Response response = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": courseId.toString(),
    });

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("courseId", courseId.toString());
      print("Added to WatchList");
    } else {
      print("Didn't add to WatchList");
    }
  }

  Future<void> removeFromWatchList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("courseId")) {
      String courseId = sharedPreferences.getString("courseId");

      String url = APIData.deleteFromWatchlist + APIData.secretKey;

      http.Response response = await http.post(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      }, body: {
        "course_id": courseId,
      });

      if (response.statusCode == 200) {
        await sharedPreferences.remove("courseId");
        print("Removed from WatchList");
      } else {
        print("Didn't remove from WatchList");
      }
    }
  }

  bool isWatching(int courseId) {
    for (Watchlist watchlist in watchlistModel.watchlist) {
      if (watchlist.courseId == courseId.toString()) {
        return true;
      }
    }
    return false;
  }
}
