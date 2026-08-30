const List<String> _serverMessageKeys = [
  'error_message',
  'message',
  'detail',
  'msg',
];

String extractServerErrorMessage(Object? data) {
  if (data is String) {
    final text = data.trim();
    if (text.isEmpty) {
      return '';
    }
    if (_looksLikeHtml(text)) {
      return _extractHtmlTitle(text);
    }
    return text;
  }
  if (data is Map) {
    for (final key in _serverMessageKeys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
  }
  if (data is List && data.isNotEmpty) {
    final first = data.first;
    if (first is String && first.trim().isNotEmpty) {
      return extractServerErrorMessage(first);
    }
    if (first is Map) {
      final nested = extractServerErrorMessage(first);
      if (nested.isNotEmpty) {
        return nested;
      }
    }
  }
  return '';
}

bool _looksLikeHtml(String text) {
  final lower = text.toLowerCase();
  return text.startsWith('<') ||
      lower.contains('<!doctype') ||
      lower.contains('<html') ||
      lower.contains('<head') ||
      lower.contains('<body');
}

String _extractHtmlTitle(String html) {
  final match = RegExp(
    r'<title[^>]*>([\s\S]*?)</title>',
    caseSensitive: false,
  ).firstMatch(html);
  return match?.group(1)?.trim() ?? '';
}

class Failure implements Exception {
  Failure(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
