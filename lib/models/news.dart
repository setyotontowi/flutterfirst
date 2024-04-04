class News {
  final String? author;
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;
  final Source source;

  const News({
    this.author = "",
    this.title = "",
    this.description = "",
    this.urlToImage = "",
    this.url = "",
    this.source = const Source(),
  });

  factory News.fromJson(Map<String, dynamic> map) {
    Source source = Source();
    if (map['source'] != null) {
      source = Source.fromJson(map['source']);
    }

    return News(
      author: map["author"],
      title: map["title"],
      description: map["description"],
      urlToImage: map["urlToImage"],
      url: map["url"],
      source: source,
    );
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
}
