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
      // Her bir kelimeyi ayrı ayrı işle ve sonra birleştir
      return words
          .map(
            (word) =>
                word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
          )
          .join(' ');
    }
    return this[0].toUpperCase() + substring(1);
  }

  bool validateEmail() {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }
}

extension EndPointExtension on String {
  String asPublicEndPoint() {
    return "/public$this";
  }

  String withQueryParams(
    Map<String, dynamic> queryParams, {
    int? page,
    int? size,
  }) {
    final List<String> elements = [];
    for (var entry in queryParams.entries) {
      var element = "${entry.key}=${entry.value}";
      elements.add(element);
    }
    if (page != null) {
      elements.add("page=$page");
    }
    if (size != null) {
      elements.add("size=$size");
    }
    return "$this?${elements.join("&")}";
  }
}
