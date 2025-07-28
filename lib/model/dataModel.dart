class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
  });

  // طريقة لتحويل JSON إلى كائن Article
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  // طريقة لتحويل الكائن إلى JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt?.toIso8601String(),
  };
}