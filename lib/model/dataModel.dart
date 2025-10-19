class ArticleModel {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  ArticleModel({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? ''
    );
  }
}

class ListConvertor {
  final List<ArticleModel> data;

  ListConvertor(this.data);

  factory ListConvertor.fromJson(List<dynamic> jsonData){
    List<ArticleModel> data = [];
    data = jsonData.map((item) => ArticleModel.fromJson(item)).toList();
    return ListConvertor(data);
  }
}