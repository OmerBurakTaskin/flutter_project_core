import 'package:intl/intl.dart';

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

  String? formatTimeForServer() {
    if (isEmpty) return null;

    final parts = split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);

    final offset = dt.timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';

    final formatted =
        '${DateFormat('HH:mm:ss').format(dt)}$sign$hours:$minutes';

    return formatted;
  }
}

extension EndPointExtension on String {
  String asPublicEndPoint() {
    return "/public$this";
  }

  String withQueryParams(Map<String, dynamic> queryParams) {
    final List<String> elements = [];
    for (var entry in queryParams.entries) {
      var element = "${entry.key}=${entry.value}";
      elements.add(element);
    }

    return "$this?${elements.join("&")}";
  }
}
