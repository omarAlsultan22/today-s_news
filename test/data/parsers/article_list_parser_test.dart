import 'package:flutter_test/flutter_test.dart';
import 'package:todays_news/data/parsers/article_list_parser.dart';


void main() {
  group('ArticleListParser.fromJson', () {
    test('parses a list of valid article JSONs', () {
      final json = [
        {
          'title': 'A',
          'description': 'D1',
          'url': 'https://a',
          'urlToImage': 'https://a.jpg',
          'publishedAt': '2024-05-01',
        },
        {
          'title': 'B',
          'description': 'D2',
          'url': 'https://b',
          'urlToImage': 'https://b.jpg',
          'publishedAt': '2024-05-02',
        },
      ];

      final result = ArticleListParser.fromJson(json);

      expect(result.data.length, 2);
      expect(result.data[0].title, 'A');
      expect(result.data[1].title, 'B');
    });

    test('returns empty list for empty JSON', () {
      final result = ArticleListParser.fromJson([]);
      expect(result.data, isEmpty);
    });

    test('handles missing optional fields gracefully', () {
      final json = [{'title': 'A'}];
      final result = ArticleListParser.fromJson(json);
      expect(result.data.length, 1);
      expect(result.data.first.title, 'A');
    });

    // إذا كان Parser يرمي عند JSON غير صالح:
    test('throws when item is not a Map', () {
      expect(
            () => ArticleListParser.fromJson(['not-a-map']),
        throwsA(isA<TypeError>()),
      );
    });
  });
}