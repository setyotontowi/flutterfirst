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
    final List<String> newsList = await _getNewsList();

    if (newsList.any((element) => element.contains('${news.url}'))) {
      await deleteNews(news);
    } else {
      newsList.add(jsonEncode(news.toJson()));
      await _saveNewsList(newsList);
    }
  }

  static Future<List<News>> getFavorites() async {
    final List<String> newsList = await _getNewsList();
    return newsList.map((encodedNews) => News.fromJson(jsonDecode(encodedNews))).toList();
  }

  static Future<void> deleteNews(News news) async {
    final List<String> newsList = await _getNewsList();
    final updatedNewsList = newsList.where((encodedNews) {
      final decodedNews = News.fromJson(jsonDecode(encodedNews));
      return decodedNews.url != news.url;
    }).toList();
    await _saveNewsList(updatedNewsList);
  }

  static Future<List<String>> _getNewsList() async {
    if (kIsWeb) {
      final String? jsonString = html.window.localStorage[_favoritesKey];
      return jsonString != null ? jsonDecode(jsonString).cast<String>() : [];
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getStringList(_favoritesKey) ?? [];
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }

  static Future<void> _saveNewsList(List<String> newsList) async {
    if (kIsWeb) {
      html.window.localStorage[_favoritesKey] = jsonEncode(newsList);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setStringList(_favoritesKey, newsList);
    } else {
      throw PlatformException(code: "ERR01", message: "Platform Not Supported");
    }
  }
}
