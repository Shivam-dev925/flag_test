/// Search utilities for the application
///
/// Provides helper functions for search and filtering operations.
library;

class SearchUtils {
  SearchUtils._();

  /// Performs case-insensitive search
  static bool containsIgnoreCase(String source, String query) {
    return source.toLowerCase().contains(query.toLowerCase());
  }

  /// Fuzzy search - allows for small typos
  ///
  /// Returns true if the query matches the source with small variations
  static bool fuzzyMatch(String source, String query) {
    if (query.isEmpty) return true;
    if (source.isEmpty) return false;

    final sourceLower = source.toLowerCase();
    final queryLower = query.toLowerCase();

    // Exact match
    if (sourceLower.contains(queryLower)) return true;

    // Check if all characters in query appear in order in source
    int sourceIndex = 0;
    for (int queryIndex = 0; queryIndex < queryLower.length; queryIndex++) {
      final char = queryLower[queryIndex];
      bool found = false;

      while (sourceIndex < sourceLower.length) {
        if (sourceLower[sourceIndex] == char) {
          found = true;
          sourceIndex++;
          break;
        }
        sourceIndex++;
      }

      if (!found) return false;
    }

    return true;
  }

  /// Highlights matching text in a string
  ///
  /// Returns a list of TextSpan objects with highlighted matches
  static List<Map<String, dynamic>> highlightMatches(
    String text,
    String query,
  ) {
    if (query.isEmpty) {
      return [
        {'text': text, 'highlight': false}
      ];
    }

    final List<Map<String, dynamic>> result = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int lastIndex = 0;
    int matchIndex = lowerText.indexOf(lowerQuery, lastIndex);

    while (matchIndex != -1) {
      // Add text before match
      if (matchIndex > lastIndex) {
        result.add({
          'text': text.substring(lastIndex, matchIndex),
          'highlight': false,
        });
      }

      // Add matched text
      result.add({
        'text': text.substring(matchIndex, matchIndex + query.length),
        'highlight': true,
      });

      lastIndex = matchIndex + query.length;
      matchIndex = lowerText.indexOf(lowerQuery, lastIndex);
    }

    // Add remaining text
    if (lastIndex < text.length) {
      result.add({
        'text': text.substring(lastIndex),
        'highlight': false,
      });
    }

    return result;
  }

  /// Filters a list of items by search query
  ///
  /// Uses fuzzy matching for better UX
  static List<T> filterList<T>(
    List<T> items,
    String query,
    String Function(T) getSearchText,
  ) {
    if (query.isEmpty) return items;

    return items.where((item) {
      final searchText = getSearchText(item);
      return fuzzyMatch(searchText, query);
    }).toList();
  }

  /// Sorts search results by relevance
  ///
  /// Exact matches first, then partial matches
  static List<T> sortByRelevance<T>(
    List<T> items,
    String query,
    String Function(T) getSearchText,
  ) {
    if (query.isEmpty) return items;

    final List<T> sortedItems = List.from(items);
    final lowerQuery = query.toLowerCase();

    sortedItems.sort((a, b) {
      final aText = getSearchText(a).toLowerCase();
      final bText = getSearchText(b).toLowerCase();

      // Exact matches first
      final aExact = aText == lowerQuery;
      final bExact = bText == lowerQuery;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      // Starts with query
      final aStarts = aText.startsWith(lowerQuery);
      final bStarts = bText.startsWith(lowerQuery);
      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;

      // Contains query
      final aContains = aText.contains(lowerQuery);
      final bContains = bText.contains(lowerQuery);
      if (aContains && !bContains) return -1;
      if (!aContains && bContains) return 1;

      // Alphabetical as fallback
      return aText.compareTo(bText);
    });

    return sortedItems;
  }
}
