import 'package:flutter/material.dart';

abstract class CoreStatefulWidget extends StatefulWidget {
  const CoreStatefulWidget({super.key});

  @override
  CoreState createState();
}

abstract class CoreState<T extends CoreStatefulWidget> extends State<T> {
  // can be overriden
  void postFrameCallback() {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => postFrameCallback());
  }
}
