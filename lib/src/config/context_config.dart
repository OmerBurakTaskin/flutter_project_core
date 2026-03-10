import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

BuildContext? get globalContext => navigatorKey.currentContext;
