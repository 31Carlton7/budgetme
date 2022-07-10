extension StringExtension on String {
  String toCamelCase() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
