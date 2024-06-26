import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/favorites_cubit.dart';
import 'package:velmo/bloc/news_cubit.dart';
import 'package:velmo/models/news.dart';

class NewsPage extends StatelessWidget {
  NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    NewsCubit cubit = context.read();
    FavoritesCubit favsCubit = context.read();

    return BlocBuilder<NewsCubit, List<News>>(
        bloc: cubit,
        builder: (context, state) {
          return Scaffold(
            body: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: state.length,
                itemBuilder: (context, index) {
                  String urlImage = state[index].urlToImage ?? "";
                  return FutureBuilder(
                      future: _loadImage(urlImage),
                      builder: (context, snapshot) {
                        if (snapshot.stackTrace != null) {
                          return SizedBox.shrink();
                        } else {
                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 4,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    child: Image.network(
                                      urlImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      errorBuilder: (context, exception, stack) {
                                        return SizedBox.shrink();
                                      },
                                    ),
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
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              state[index].title ?? "",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                          ToggleFavorites(favsCubit: favsCubit, news: state[index])
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
                          );
                        }
                      });
                }),
          );
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
      throw error;
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
            ? Icons.favorite
            : Icons.favorite_border),
      ),
    );
  }
}
