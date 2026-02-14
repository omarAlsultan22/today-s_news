import '../../../data/models/article_Model.dart';


class ArticleListParser {
  final List<Article> data;

  ArticleListParser(this.data);

  factory ArticleListParser.fromJson(List<dynamic> jsonData){
    List<Article> data = [];
    data = jsonData.map((item) => Article.fromJson(item)).toList();
    return ArticleListParser(data);
  }
}