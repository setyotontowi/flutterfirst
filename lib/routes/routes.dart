import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/favorites_cubit.dart';
import 'package:velmo/bloc/news_cubit.dart';
import 'package:velmo/page/404.dart';
import 'package:velmo/page/favorites_page.dart';
import 'package:velmo/page/home_page.dart';
import 'package:velmo/page/news_page.dart';

class MyRoutes {
  final NewsCubit newsCubit = NewsCubit();
  final FavoritesCubit favoritesCubit = FavoritesCubit();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: newsCubit),
                    BlocProvider.value(value: favoritesCubit)
                  ],
                  child: HomePage(),
                ));
      case "/favorites":
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: favoritesCubit,
                  child: FavoritesPage(),
                ));
      default:
        return MaterialPageRoute(builder: (context) => const NotFoundPage());
    }
  }
}
