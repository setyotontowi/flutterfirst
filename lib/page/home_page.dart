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
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(state[index].avatar),
                      Text(
                        state[index].firstName,
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
