extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String initials() {
    return this.split(' ').map((e) => e[0]).join();
  }
}
