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
    if (kIsWeb) {
      final List<String> newsList = [];
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        newsList.addAll(jsonDecode(jsonString));
      }
      newsList.add(jsonEncode(news));
      html.window.localStorage[_favoritesKey] = jsonEncode(newsList);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final List<String> newsList = pref.getStringList(_favoritesKey) ?? [];
      newsList.add(jsonEncode(news));
      await pref.setStringList(_favoritesKey, newsList);
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }

  static Future<List<News>> getFavorites() async {
    if (kIsWeb) {
      final List<String> newsList = [];
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        newsList.addAll(jsonDecode(jsonString));
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
      final List<String> newsList = [];
      final String? jsonString = html.window.localStorage[_favoritesKey];
      if (jsonString != null) {
        final updatedNewsList = newsList.where((encodedNews) {
          final decodedNews = News.fromJson(jsonDecode(encodedNews));
          return decodedNews.url != news.url;
        }).toList();
        html.window.localStorage[_favoritesKey] = jsonEncode(updatedNewsList);
      }
      newsList.add(jsonEncode(news));
      html.window.localStorage[_favoritesKey] = jsonEncode(newsList);
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
}
