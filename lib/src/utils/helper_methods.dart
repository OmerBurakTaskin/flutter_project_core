import 'package:flutter/foundation.dart';

void printIfDebug(Object object) {
  if (!kDebugMode) return;
  if (object is Error) {
    debugPrint("Error: ${object.stackTrace}");
    return;
  }

  debugPrint(object.toString());
}
