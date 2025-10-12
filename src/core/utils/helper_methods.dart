import 'package:flutter/material.dart';

void printIfDebug(Object object) {
  if (object is Error) {
    debugPrint("Error: ${object.stackTrace}");
    return;
  }

  debugPrint(object.toString());
}
