import 'package:velmo/models/news.dart';

abstract class NewsState {}

class NewsInit extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news; 
  
  NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}