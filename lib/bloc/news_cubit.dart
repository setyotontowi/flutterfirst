import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/models/news.dart';
import 'package:velmo/services/api/news_api.dart';
import 'package:velmo/services/api_services.dart';
import 'package:velmo/services/local_service.dart';

class NewsCubit extends Cubit<List<News>> {
  NewsCubit() : super([]) {
    refresh();
  }

  List<News> listNews = [];

  Future<void> refresh() async {
    listNews = await ApiService.getInstance().getNews();
    emit(listNews);
  }
}
