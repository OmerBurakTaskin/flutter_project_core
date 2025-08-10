import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'core/di/di.dart';
import 'core/providers/user_provider.dart';
import 'core/routes/app_routes.dart';
import 'l10n/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializeDependencies.initialize();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: MaterialApp(
        title: 'Mobile Core',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        localizationsDelegates: Localization.delegates,
        routes: appRoutes,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userProvider);
    //ref.read(connectionProvider); use if you want to initialize connection provider eagerly
    return child;
  }
}
