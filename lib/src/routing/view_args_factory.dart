import 'package:flutter_project_core/src/routing/view_args_resolver.dart';

/// Hicbir strateji gelen degeri tanimadi.
///
/// Mesaj degeri DEGIL yalnizca tipini tasir: arguman kullanici verisi
/// olabiliyor ve hata mesajlari loglara dusuyor.
class ViewArgsUnresolved implements Exception {
  const ViewArgsUnresolved(this.targetType, this.inputType);

  final Type targetType;
  final Type inputType;

  @override
  String toString() =>
      'ViewArgsUnresolved: no resolver for $inputType -> $targetType';
}

/// Stratejileri sirayla dener; ilk tanidik olan kazanir.
///
/// Sira anlamlidir: hazir nesneyi geciren strateji, kimlikten ag uzerinden
/// ceken stratejiden once gelmelidir.
class ViewArgsFactory<T> {
  const ViewArgsFactory(this.resolvers);

  final List<ViewArgsResolver<T>> resolvers;

  Future<T> resolve(Object? input) {
    for (final resolver in resolvers) {
      if (resolver.canResolve(input)) return resolver.resolve(input);
    }
    return Future.error(ViewArgsUnresolved(T, input.runtimeType));
  }

  /// Cozulemeyen arguman ekrani patlatmak yerine [fallback]a duser; rota
  /// hem hazir nesneyi hem de eksik bir derin baglantiyi karsilayabilsin.
  Future<T> resolveOr(Object? input, Future<T> Function() fallback) async {
    for (final resolver in resolvers) {
      if (resolver.canResolve(input)) return resolver.resolve(input);
    }
    return fallback();
  }
}
