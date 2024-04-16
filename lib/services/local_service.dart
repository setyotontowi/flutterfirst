import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velmo/models/news.dart';

class LocalService {
  static const String _favoritesKey = "FAVORITES";

  static Future<void> addFavorites(News news) async {
    List<String> newsList = [];
    bool exist = false;

    if (kIsWeb) {
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        newsList = jsonToListObject(jsonString);

        for (var element in newsList) {
          if (element.contains('${news.url}')) exist = true;
        }
      }

      if (exist) {
        deleteNews(news);
      } else {
        newsList.add(jsonEncode(news.toJson()));
        html.window.localStorage[_favoritesKey] = jsonEncode(newsList);
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      newsList = pref.getStringList(_favoritesKey) ?? [];

      for (var element in newsList) {
        if (element.contains('${news.url}')) exist = true;
      }

      if (exist) {
        deleteNews(news);
      } else {
        newsList.add(jsonEncode(news.toJson()));
        await pref.setStringList(_favoritesKey, newsList);
      }
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }

  static Future<List<News>> getFavorites() async {
    if (kIsWeb) {
      final List<String> newsList = [];
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        final List<dynamic> decode = jsonDecode(jsonString);
        newsList.addAll(decode.map((e) => e.toString()).toList());
        return newsList.map((encodedNews) => News.fromJson(jsonDecode(encodedNews))).toList();
      }
      return [];
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final List<String> newsList = pref.getStringList(_favoritesKey) ?? [];
      return newsList.map((encodedNews) => News.fromJson(jsonDecode(encodedNews))).toList();
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }

  static Future<void> deleteNews(News news) async {
    if (kIsWeb) {
      List<News> newsList = [];
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        newsList = jsonToListNews(jsonToListObject(jsonString));

        final updatedNewsList = newsList.where((storageNews) {
          return storageNews.url != news.url;
        }).toList();

        final jsonFinal = updatedNewsList.map((n) => n.toJson()).toList();
        html.window.localStorage[_favoritesKey] = jsonEncode(jsonFinal);
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final List<String> newsList = pref.getStringList(_favoritesKey) ?? [];
      if (newsList.isNotEmpty) {
        final updatedNewsList = newsList.where((encodedNews) {
          final decodedNews = News.fromJson(jsonDecode(encodedNews));
          return decodedNews.url != news.url;
        }).toList();
        await pref.setStringList(_favoritesKey, updatedNewsList);
      }
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }

  static List<String> jsonToListObject(String json) {
    List<dynamic> decode = jsonDecode(json);
    List<String> jsonList = decode.map((str) => str.toString()).toList();
    return jsonList;
  }

  static List<News> jsonToListNews(List<String> jsonList) {
    List<News> list = jsonList.map((item) => News.fromJson(jsonDecode(item))).toList();
    return list;
  }
}
