extension StringHashing on String {
  String obscureText({int start = 0, int end = 0, String replacement = "*"}) {
    if (start < 0 || end < 0 || start >= length || end >= length) {
      return this;
    }
    String prefix = substring(0, start);
    String suffix = substring(end);
    String obscuredPart = replacement * (end - start);
    return "$prefix$obscuredPart$suffix";
  }
}

extension StringFormatting on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    final words = split(' ');
    if (words.length > 1) {
      return words.map((word) => capitalizeFirstLetter()).join(' ');
    }
    return this[0].toUpperCase() + substring(1);
  }

  bool validateEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}
