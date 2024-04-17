import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/models/news.dart';
import 'package:velmo/services/local_service.dart';

class FavoritesCubit extends Cubit<List<News>> {
  FavoritesCubit() : super([]) {
    getFavorites();
  }

  List<News> favorites = [];
  Set<String> favoritesSet = {};

  Future<void> getFavorites() async {
    favorites = await LocalService.getFavorites();
    favoritesSet = favorites
        .map(
          (e) => e.url ?? "",
        )
        .toSet();
    emit(favorites);
  }

  Future<void> saveFavorites(News news) async {
    await LocalService.addFavorites(news);
    getFavorites();
  }

  bool isFavorites(String url) {
    return favoritesSet.contains(url);
  }
}
