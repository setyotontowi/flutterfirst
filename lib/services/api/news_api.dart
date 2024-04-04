import 'dart:convert';

import 'package:velmo/models/news.dart';
import 'package:velmo/services/api_services.dart';

extension NewsApi on ApiService {
  Future<List<News>> getNews() async {
    final res = await get("api/users?page=1");
    if (res.statusCode != 200) return [];

    final Map<String, dynamic> body = jsonDecode(res.body);
    List<News> _news = (body['data'] as List<dynamic>).map((e) => News.fromJson(e)).toList();
    return _news;
  }
}
