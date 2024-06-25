import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/state/news_state.dart';
import 'package:velmo/models/news.dart';
import 'package:velmo/services/api/news_api.dart';
import 'package:velmo/services/api_services.dart';



// [x] TODO 1: can we emit partial from a list from cubit? for example, emit 5 first in a 100 list while we fetch another info for the rest of list?
// [ ] TODO 2: figure out how to simplify the filter

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInit()) {
    refresh();
  }

  List<News> listNews = [];
  List<News> filteredNews = [];
  int batchSize = 1;

  Future<void> refresh() async {
    emit(NewsLoading());

    listNews = await ApiService.getInstance().getNews();
    await _filterValidNews();
    emit(NewsLoaded(filteredNews));
  }

  Future<void> _filterValidNews() async {
    for (int i = 0; i < listNews.length; i++) {
      News news = listNews[i];
      if (news.urlToImage != null && news.urlToImage!.isNotEmpty) {
        try {
          await _loadImage(news.urlToImage!);
          filteredNews.add(news);
        } catch (error) {
          // Image failed to load, do not add to filteredNews
        }

        if (i % batchSize == 0 && i != 0) {
          print("batch is batching");
          emit(NewsLoaded(List.from(filteredNews)));
        }
      }
    }
  }

  Future<void> _loadImage(String url) async {
    try {
      final image = NetworkImage(url);
      final Completer<void> completer = Completer<void>();
      image.resolve(ImageConfiguration()).addListener(
            ImageStreamListener(
              (info, _) {
                completer.complete();
              },
              onError: (error, stackTrace) {
                completer.completeError(error, stackTrace);
              },
            ),
          );
      await completer.future;
    } catch (error) {
      // Catch any exceptions that occur during image loading
      rethrow;

    }
  }
}
