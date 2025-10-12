import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final connectionProvider= StreamProvider<InternetStatus>(
  (ref) => InternetConnection.createInstance().onStatusChange
);