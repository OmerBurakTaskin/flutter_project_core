import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionService {
  final InternetConnection _internetConnection = InternetConnection();
  late final Stream<InternetStatus> connectionStream;

  ConnectionService() {
    connectionStream = _internetConnection.onStatusChange;
  }

  Future<bool> checkConnection() async {
    return await _internetConnection.hasInternetAccess;
  }

  Stream<InternetStatus> connections() {
    final controller = StreamController<InternetStatus>.broadcast();

    _internetConnection.onStatusChange.listen((status) async {
      if (status == InternetStatus.disconnected) {
        await Future.delayed(Duration(milliseconds: 500)); 
        final result = await _internetConnection.hasInternetAccess;

        if (!result) {
          controller.add(InternetStatus.disconnected);
        }
      } else {
        controller.add(InternetStatus.connected);
      }
    });

    return controller.stream
        .asBroadcastStream()
        .transform(StreamTransformer.fromHandlers(
      handleDone: (sink) {
        sink.close();
        controller.close();
      },
    ));
  }
}
