import 'dart:convert';

import 'package:velmo/models/news.dart';
import 'package:velmo/services/api_services.dart';

extension NewsApi on ApiService {
  Future<List<News>> getNews() async {
    final res = await get("api/users?page=1");
    if (res.statusCode != 200) return [];

    final body = jsonDecode(res.body);
    return body["data"].map((e) => {News.fromJson(e)}).toList();
  }
}
