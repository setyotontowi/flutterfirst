import 'package:intl/intl.dart';

class News {
  final String? author;
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;
  final DateTime? publishedAt;
  final Source source;

  const News({
    this.author = "",
    this.title = "",
    this.description = "",
    this.urlToImage = "",
    this.url = "",
    this.publishedAt,
    this.source = const Source(),
  });

  factory News.fromJson(Map<String, dynamic> map) {
    Source source = Source();
    if (map['source'] != null) {
      source = Source.fromJson(map['source']);
    }

    final publishedAtString = map["publishedAt"];
    final publishedAt = DateTime.parse(publishedAtString);

    return News(
      author: map["author"],
      title: map["title"],
      description: map["description"],
      urlToImage: map["urlToImage"],
      url: map["url"],
      publishedAt: publishedAt,
      source: source,
    );
  }

  Map<String, dynamic> toJson() {
    final format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

    return {
      'author': author,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
      'publishedAt': format.format(publishedAt ?? DateTime.now()),
      'source': source.toJson()
    };
  }
}

class Source {
  final String? id;
  final String name;

  const Source({
    this.id = "",
    this.name = "",
  });

  factory Source.fromJson(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
