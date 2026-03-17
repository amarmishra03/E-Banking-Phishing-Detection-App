class UrlExtractor {

  static List<String> extractUrls(String text) {

    final urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    return urlRegex
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList();
  }

}