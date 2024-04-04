import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/news_cubit.dart';
import 'package:velmo/page/404.dart';
import 'package:velmo/page/home_page.dart';

class MyRoutes {
  final NewsCubit newsCubit = NewsCubit();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: newsCubit,
                  child: HomePage(),
                ));
      default:
        return MaterialPageRoute(builder: (context) => const NotFoundPage());
    }
  }
}
