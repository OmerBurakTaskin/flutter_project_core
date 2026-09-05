import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/widgets/custom_scaffold.dart';

typedef FutureWidgetBuilder<T> = Widget Function(BuildContext context, T data);

typedef FutureErrorBuilder =
    Widget Function(BuildContext context, Object error);

/// [future]'i BIR KEZ baslatir ve sonucu [builder]'a verir.
///
/// Future initState'te sabitlenir; dogrudan `FutureBuilder`a verilseydi her
/// yeniden cizimde yeni bir istek baslardi.
class CustomFutureBuilder<T> extends StatefulWidget {
  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.loading,
    this.errorBuilder,
  });

  final Future<T> future;
  final FutureWidgetBuilder<T> builder;
  final Widget? loading;
  final FutureErrorBuilder? errorBuilder;

  @override
  State<CustomFutureBuilder<T>> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  late final Future<T> _future = widget.future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomScaffold(
            body: Center(
              child:
                  widget.loading ?? const CircularProgressIndicator.adaptive(),
            ),
          );
        }

        final error = snapshot.error;
        if (error != null) {
          return widget.errorBuilder?.call(context, error) ??
              ErrorWidget(error);
        }

        if (snapshot.hasData) return widget.builder(context, snapshot.data as T);

        return const SizedBox.shrink();
      },
    );
  }
}
