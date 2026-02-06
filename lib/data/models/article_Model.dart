import 'package:hive/hive.dart';
part 'article_Model.g.dart';


@HiveType(typeId: 0)
class Article {

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String urlToImage;

  @HiveField(4)
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
        url: json['url'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        urlToImage: json['urlToImage'] ?? '',
        publishedAt: json['publishedAt'] ?? ''
    );
  }
}


