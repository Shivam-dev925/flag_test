import 'package:flutter_test/flutter_test.dart';
import 'package:feature_flag_demo/utils/search_utils.dart';

void main() {
  group('SearchUtils', () {
    group('containsIgnoreCase', () {
      test('returns true for exact match', () {
        expect(SearchUtils.containsIgnoreCase('Hello World', 'Hello'), isTrue);
      });

      test('returns true for case-insensitive match', () {
        expect(SearchUtils.containsIgnoreCase('Hello World', 'hello'), isTrue);
        expect(SearchUtils.containsIgnoreCase('Hello World', 'WORLD'), isTrue);
      });

      test('returns false when query not found', () {
        expect(SearchUtils.containsIgnoreCase('Hello World', 'foo'), isFalse);
      });
    });

    group('fuzzyMatch', () {
      test('returns true for exact match', () {
        expect(SearchUtils.fuzzyMatch('doctor', 'doctor'), isTrue);
      });

      test('returns true for partial match', () {
        expect(SearchUtils.fuzzyMatch('doctor', 'doc'), isTrue);
        expect(SearchUtils.fuzzyMatch('doctor', 'tor'), isTrue);
      });

      test('returns true for characters in order', () {
        expect(SearchUtils.fuzzyMatch('doctor', 'dcr'), isTrue);
        expect(SearchUtils.fuzzyMatch('hello world', 'hllwrd'), isTrue);
      });

      test('returns false for characters out of order', () {
        expect(SearchUtils.fuzzyMatch('doctor', 'tco'), isFalse);
      });

      test('returns true for empty query', () {
        expect(SearchUtils.fuzzyMatch('anything', ''), isTrue);
      });

      test('returns false for empty source', () {
        expect(SearchUtils.fuzzyMatch('', 'query'), isFalse);
      });
    });

    group('highlightMatches', () {
      test('returns single item for no matches', () {
        final result = SearchUtils.highlightMatches('Hello World', 'xyz');
        expect(result.length, 1);
        expect(result[0]['text'], 'Hello World');
        expect(result[0]['highlight'], false);
      });

      test('highlights single match', () {
        final result = SearchUtils.highlightMatches('Hello World', 'Hello');
        expect(result.length, 2);
        expect(result[0]['text'], 'Hello');
        expect(result[0]['highlight'], true);
        expect(result[1]['text'], ' World');
        expect(result[1]['highlight'], false);
      });

      test('highlights multiple matches', () {
        final result = SearchUtils.highlightMatches('la la land', 'la');
        expect(result.length, 5);
        expect(result[0]['highlight'], true); // 'la'
        expect(result[1]['highlight'], false); // ' '
        expect(result[2]['highlight'], true); // 'la'
        expect(result[3]['highlight'], false); // ' '
        expect(result[4]['highlight'], false); // 'land'
      });
    });

    group('filterList', () {
      final testItems = ['Apple', 'Banana', 'Cherry', 'Date'];

      test('returns all items for empty query', () {
        final result = SearchUtils.filterList(
          testItems,
          '',
          (item) => item,
        );
        expect(result.length, 4);
      });

      test('filters by exact match', () {
        final result = SearchUtils.filterList(
          testItems,
          'Apple',
          (item) => item,
        );
        expect(result.length, 1);
        expect(result[0], 'Apple');
      });

      test('filters by fuzzy match', () {
        final result = SearchUtils.filterList(
          testItems,
          'ban',
          (item) => item,
        );
        expect(result.length, 1);
        expect(result[0], 'Banana');
      });
    });

    group('sortByRelevance', () {
      final testItems = [
        'doctor',
        'doctorate',
        'medical doctor',
        'the doctor',
      ];

      test('sorts exact matches first', () {
        final result = SearchUtils.sortByRelevance(
          testItems,
          'doctor',
          (item) => item,
        );
        expect(result[0], 'doctor'); // Exact match first
      });

      test('sorts starts-with matches second', () {
        final result = SearchUtils.sortByRelevance(
          testItems,
          'doc',
          (item) => item,
        );
        expect(result[0], 'doctor'); // Starts with 'doc'
        expect(result[1], 'doctorate'); // Starts with 'doc'
      });

      test('returns unchanged list for empty query', () {
        final result = SearchUtils.sortByRelevance(
          testItems,
          '',
          (item) => item,
        );
        expect(result, testItems);
      });
    });
  });
}
