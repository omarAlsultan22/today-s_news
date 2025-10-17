class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? ''
    );
  }
}

class ListConvertor {
  final List<Article> data;

  ListConvertor(this.data);

  factory ListConvertor.fromJson(List<dynamic> jsonData){
    List<Article> data = [];
    data = jsonData.map((item) => Article.fromJson(item)).toList();
    return ListConvertor(data);
  }
}