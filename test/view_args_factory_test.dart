import 'package:flutter_project_core/axii_core.dart';
import 'package:flutter_test/flutter_test.dart';

class _Order {
  const _Order(this.id);
  final String id;
}

class _OrderIdResolver extends ViewArgsResolver<_Order> {
  _OrderIdResolver();

  final List<String> fetched = [];

  @override
  bool canResolve(Object? input) =>
      input is Map<String, dynamic> && input['orderId'] is String;

  @override
  Future<_Order> resolve(Object? input) async {
    final id = (input as Map<String, dynamic>)['orderId'] as String;
    fetched.add(id);
    return _Order(id);
  }
}

void main() {
  test('hazir nesne oldugu gibi gecer, ag stratejisi calismaz', () async {
    final remote = _OrderIdResolver();
    final factory = ViewArgsFactory<_Order>([
      const PassThroughResolver<_Order>(),
      remote,
    ]);

    final order = await factory.resolve(const _Order('a'));

    expect(order.id, 'a');
    expect(remote.fetched, isEmpty);
  });

  test('kimlik tasiyan harita ikinci strateji ile cozulur', () async {
    final remote = _OrderIdResolver();
    final factory = ViewArgsFactory<_Order>([
      const PassThroughResolver<_Order>(),
      remote,
    ]);

    final order = await factory.resolve({'orderId': 'b'});

    expect(order.id, 'b');
    expect(remote.fetched, ['b']);
  });

  test('siradaki ilk tanidik strateji kazanir', () async {
    final first = _OrderIdResolver();
    final second = _OrderIdResolver();
    final factory = ViewArgsFactory<_Order>([first, second]);

    await factory.resolve({'orderId': 'c'});

    expect(first.fetched, ['c']);
    expect(second.fetched, isEmpty);
  });

  test('tanimadigi girdi ViewArgsUnresolved firlatir', () async {
    final factory = ViewArgsFactory<_Order>([
      const PassThroughResolver<_Order>(),
    ]);

    await expectLater(
      factory.resolve(42),
      throwsA(isA<ViewArgsUnresolved>()),
    );
  });

  test('hata mesaji arguman DEGERINI tasimaz', () {
    // Arguman kullanici verisi olabilir ve mesaj loglara duser.
    const error = ViewArgsUnresolved(_Order, String);

    expect(error.toString(), contains('String'));
    expect(error.toString(), contains('_Order'));
  });

  test('resolveOr cozulemeyen girdide yedege duser', () async {
    final factory = ViewArgsFactory<_Order>([
      const PassThroughResolver<_Order>(),
    ]);

    final order = await factory.resolveOr(null, () async => const _Order('x'));

    expect(order.id, 'x');
  });

  test('resolveOr cozulen girdide yedege dusmez', () async {
    final factory = ViewArgsFactory<_Order>([
      const PassThroughResolver<_Order>(),
    ]);

    final order = await factory.resolveOr(
      const _Order('a'),
      () async => const _Order('x'),
    );

    expect(order.id, 'a');
  });

  test('InlineViewArgsResolver sinif acmadan strateji tanimlar', () async {
    final factory = ViewArgsFactory<_Order>([
      InlineViewArgsResolver<_Order>(
        canResolve: (input) => input is String,
        resolve: (input) async => _Order(input as String),
      ),
    ]);

    expect((await factory.resolve('z')).id, 'z');
  });
}
