class NameFormatter {
  NameFormatter._(); // private constructor to prevent instantiation

  /// Formats a full name:
  /// - Trims extra spaces
  /// - Capitalizes each word
  /// - Returns 'User' if null or empty
  static String formatFullName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return 'User';

    // Split by spaces, remove empty segments, capitalize each word
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .toList();

    return words.join(' ');
  }
}
