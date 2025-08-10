import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String onBoarding = '/onBoarding';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String transaction = '/transaction';
  static const String withdrawMoney = '/withdrawMoney';
  static const String addMoney = '/addMoney';
  static const String requestMoney = '/requestMoney';
  static const String viewTransactions = '/transactions';
  static const String loginWithPin = '/loginWithPin';
  static const String createPassword = '/createPassword';
  static const String agent = '/agent';
  static const String notifications = '/notifications';
}

Map<String, WidgetBuilder> appRoutes = {};

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
