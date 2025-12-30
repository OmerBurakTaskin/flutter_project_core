import 'dart:math';
import 'package:flutter/material.dart';

extension GenerateListExtension on num {
  List<T> to<T extends num>(num to, {num? step}) {
    final list = <T>[];
    final start = min(this, to);
    final end = max(to, this);
    final stepp = step ?? 1;
    for (var i = start; i <= end; i += stepp) {
      if (T == int) {
        list.add(i.toInt() as T);
      } else if (T == double) {
        list.add(i.toDouble() as T);
      }
    }
    if (this > to) {
      return list.reversed.toList();
    }
    return list;
  }
}

extension SizedBoxExtension on num {
  Widget verticalSizedBox() {
    return SizedBox(height: toDouble());
  }

  Widget horizontalSizedBox() {
    return SizedBox(width: toDouble());
  }
}
