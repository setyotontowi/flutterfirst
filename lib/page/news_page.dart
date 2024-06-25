import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:velmo/bloc/favorites_cubit.dart';
import 'package:velmo/bloc/news_cubit.dart';
import 'package:velmo/bloc/state/news_state.dart';
import 'package:velmo/models/news.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewsPage extends StatefulWidget {
  NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    NewsCubit cubit = context.read();
    FavoritesCubit favsCubit = context.read();

    return BlocBuilder<NewsCubit, NewsState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is NewsLoaded) {
            return Scaffold(
            body: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  String urlImage = state.news[index].urlToImage ?? "";
                  return FutureBuilder(
                      future: _loadImage(urlImage),
                      builder: (context, snapshot) {
                        final format = DateFormat('EEEE dd MMMM, HH:mm');
                        return VisibilityDetector(
                            key: Key(index.toString()),
                            onVisibilityChanged: (VisibilityInfo info) {
                              if (info.visibleFraction == 1) {
                                setState(() {
                                  print("index $index");
                                });
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 4,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    snapshot.stackTrace == null? 
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: urlImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 300,
                                      ),
                                    ) : Container(),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(state.news[index].title ?? "",style: TextStyle(fontSize: 16.0),),
                                    ),
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                format.format(state.news[index].publishedAt ?? DateTime.now()),
                                                style: TextStyle(fontSize: 12.0),
                                              ),
                                            ),
                                            ToggleFavorites(favsCubit: favsCubit, news: state.news[index])
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                      });
                }),
          );
          } else {
            return Center(child: CircularProgressIndicator());
          }
          
        });
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

class ToggleFavorites extends StatefulWidget {
  const ToggleFavorites({
    super.key,
    required this.favsCubit,
    required this.news,
  });

  final FavoritesCubit favsCubit;
  final News news;

  @override
  State<ToggleFavorites> createState() => _ToggleFavoritesState();
}

class _ToggleFavoritesState extends State<ToggleFavorites> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: IconButton(
        key: ValueKey<bool>(widget.favsCubit.isFavorites(widget.news.url ?? "")),
        onPressed: () {
          setState(() {
            widget.favsCubit.saveFavorites(widget.news);
          });
        },
        icon: Icon(widget.favsCubit.isFavorites(widget.news.url ?? "")
            ? Icons.bookmark
            : Icons.bookmark_border),
      ),
    );
  }
}
