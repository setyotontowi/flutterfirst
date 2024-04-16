import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/models/news.dart';
import 'package:velmo/services/local_service.dart';

class FavoritesCubit extends Cubit<List<News>> {
  FavoritesCubit() : super([]) {
    getFavorites();
  }

  List<News> favorites = [];

  Future<void> getFavorites() async {
    favorites = await LocalService.getFavorites();
    emit(favorites);
  }

  Future<void> saveFavorites(News news) async {
    await LocalService.addFavorites(news);
    getFavorites();
  }
}
