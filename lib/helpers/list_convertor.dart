import '../models/data_Model.dart';


class ListConvertor {
  final List<ArticleModel> data;

  ListConvertor(this.data);

  factory ListConvertor.fromJson(List<dynamic> jsonData){
    List<ArticleModel> data = [];
    data = jsonData.map((item) => ArticleModel.fromJson(item)).toList();
    return ListConvertor(data);
  }
}