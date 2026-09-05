/// Bir ekranin bekledigi [T] argumanini, elde ne varsa ondan uretir.
///
/// Ayni ekrana farkli yerlerden farkli seyler gelir: liste ekrani hazir
/// nesneyi verir, bir bildirim ya da derin baglanti yalnizca kimligi. Her
/// kaynak icin bir strateji yazilir; rota hangisinin geldigini bilmez.
abstract class ViewArgsResolver<T> {
  const ViewArgsResolver();

  bool canResolve(Object? input);

  Future<T> resolve(Object? input);
}

/// Gelen zaten [T] ise oldugu gibi gecer. Her ekranin tekrar yazacagi
/// strateji budur; listenin BASINA konur ki hazir nesne icin ag'a gidilmesin.
class PassThroughResolver<T> extends ViewArgsResolver<T> {
  const PassThroughResolver();

  @override
  bool canResolve(Object? input) => input is T;

  @override
  Future<T> resolve(Object? input) async => input as T;
}

/// Tek kullanimlik strateji; ayri bir sinif acmaya degmeyen haller icin.
class InlineViewArgsResolver<T> extends ViewArgsResolver<T> {
  const InlineViewArgsResolver({
    required bool Function(Object? input) canResolve,
    required Future<T> Function(Object? input) resolve,
  }) : _canResolve = canResolve,
       _resolve = resolve;

  final bool Function(Object? input) _canResolve;
  final Future<T> Function(Object? input) _resolve;

  @override
  bool canResolve(Object? input) => _canResolve(input);

  @override
  Future<T> resolve(Object? input) => _resolve(input);
}
