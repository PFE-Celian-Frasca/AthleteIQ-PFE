extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    return this[0].toUpperCase() + substring(1);
  }

  String initials() {
    List<String> words = split(' ').where((word) => word.isNotEmpty).toList();
    if (words.length > 2) {
      words = words.sublist(0, 2);
    }
    return words.map((e) => e[0].toUpperCase()).join();
  }
}
