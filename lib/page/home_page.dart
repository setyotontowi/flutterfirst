import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmo/bloc/news_cubit.dart';
import 'package:velmo/models/news.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NewsCubit cubit = NewsCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, List<News>>(
        bloc: cubit,
        builder: (context, state) {
          return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: state.length,
              itemBuilder: (context, index) {
                String urlImage = state[index].urlToImage ?? "";
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Builder(builder: (context) {
                        if (!urlImage.contains("http"))
                          return SizedBox();
                        else {
                          return Container(
                            child: Image.network(
                              urlImage,
                              fit: BoxFit.fitWidth,
                              scale: 5.0,
                            ),
                          );
                        }
                      }),
                      Text(
                        state[index].title ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                );
              });
        });
  }
}
