import 'dart:convert';

extension StringExtension on String? {
  String? getErrorMessage() {
    if (this == null || this!.isEmpty) return null;

    try {
      final decoded = json.decode(this!);

      if (decoded is List) {
        final messages = decoded.whereType<String>().toList();
        return messages.isNotEmpty ? messages.join('\n') : null;
      }

      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail') && decoded['detail'] is String) {
          return decoded['detail'];
        }

        final messages = decoded.values
            .whereType<List>()
            .expand((list) => list)
            .whereType<String>()
            .toList();

        return messages.isNotEmpty ? messages.join('\n') : null;
      }
    } catch (_) {
      // Not a valid JSON
    }

    return null;
  }
}
