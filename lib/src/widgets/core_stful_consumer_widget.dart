import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CoreStatefulConsumerWidget extends ConsumerStatefulWidget {
  const CoreStatefulConsumerWidget({super.key});

  @override
  CoreStatefulConsumerState createState();
}

abstract class CoreStatefulConsumerState<T extends CoreStatefulConsumerWidget>
    extends ConsumerState<T> {
  // can be overriden
  void postFrameCallback() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => postFrameCallback());
  }
}
