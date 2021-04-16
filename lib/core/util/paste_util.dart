class PasteUtil {
  /// Generate paste link adding a trailing slash
  static String generateLink(String url, String id) {
    return '$url/$id/';
  }
}
