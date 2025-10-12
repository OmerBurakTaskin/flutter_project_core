import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/connection/conection_dialog_controller.dart';

class ConnectionWrapper extends ConsumerStatefulWidget {
  const ConnectionWrapper({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWrapperState();
}

class _ConnectionWrapperState extends ConsumerState<ConnectionWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(connectionDialogControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
