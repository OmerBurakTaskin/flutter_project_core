import 'package:flutter/material.dart';

import '../../widgets/connection_wrapper.dart';

extension ConnectionMonitorExtension on Widget {
  Widget withConnectionWrapper() {
    return ConnectionWrapper(child: this);
  }
}

extension GestureDetectorExtension on Widget {
  Widget asGestureDetector({required Function() onTap}) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque, onTap: onTap, child: this);
  }
}

extension AlignmentExtension on Widget {
  Widget alignLeft() => Align(alignment: Alignment.centerLeft, child: this);

  Widget alignRight() => Align(alignment: Alignment.centerRight, child: this);

  Widget alignTop() => Align(alignment: Alignment.topCenter, child: this);

  Widget alignBottom() => Align(alignment: Alignment.bottomCenter, child: this);

  Widget align({required Alignment alignment}) =>
      Align(alignment: alignment, child: this);
}

extension PaddingExtension on Widget {
  Widget paddingAll({required double padding}) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double? vertical, double? horizontal}) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0, vertical: vertical ?? 0),
      child: this);

  Widget paddingOnly(
          {double? left, double? right, double? top, double? bottom}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top ?? 0,
              bottom: bottom ?? 0,
              left: left ?? 0,
              right: right ?? 0),
          child: this);
}
