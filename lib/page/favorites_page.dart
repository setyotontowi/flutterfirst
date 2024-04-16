import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/favorites_cubit.dart';
import 'package:velmo/models/news.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<News>>(
        bloc: context.read(),
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
                                  Padding(
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
                                        IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
                                      ],
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
