import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

get globalContext => navigatorKey.currentContext;
