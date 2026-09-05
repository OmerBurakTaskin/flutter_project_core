# Flutter Project Core

Shared core layer for Flutter applications.

This package contains reusable building blocks that are shared across multiple apps:
networking, extensions, common widgets, models, theme utilities and helpers.

Designed to keep feature modules clean and reduce duplication.

---

## 📦 Contents

### Data
- `local/`
  - Local database services
- `remote/`
  - Network service abstractions

### Extensions
- String, number, future, widget and context extensions
- API response helpers

### Models
- Common response models
- Enum helpers

### Network
- Auth interceptor
- Network-related utilities

### Routing
- `ViewArgsResolver` / `ViewArgsFactory` — resolve whatever a route was handed
  into the argument a screen actually wants
- `CustomFutureBuilder` — render the resolved value once, without restarting the
  future on rebuild

### Theme
- Shared text styles

### Utils
- Helper and utility methods

### Widgets
- Reusable UI components
- Bottom sheet selections
- Custom buttons, scaffolds, avatars, images, phone field, etc.

---

## 🚀 Usage

Add the dependency:

```yaml
dependencies:
  flutter_project_core:
    git:
      url: https://github.com/OmerBurakTaskin/flutter_project_core.git
      ref: main (or selected version tag, e.g. v0.0.1)
```

---

## ☎️ Phone field

`PhoneField` pairs a country trigger with a masked national number input. Tapping the
trigger opens a searchable country bottom sheet (popular section, A–Z index, dial code
badges); the number is masked with the selected country's mask and read back as E.164.

```dart
final controller = PhoneFieldController(initialCountryCode: 'TR');

PhoneField(
  label: 'Phone Number',
  countryIsoCodes: const ['TR', 'DE', 'GB'], // empty list = every country
  phoneFieldController: controller,
)

controller.getPhoneNumber(); // +905527802864
controller.formattedNumber;  // 552 780 2864
controller.isValid;          // digits fill the country mask
```

Configure labels, colors and the popular countries once, above `MaterialApp`'s content,
instead of on every screen:

```dart
MaterialApp(
  builder: (context, child) => PhoneFieldScope(
    defaultCountryIsoCode: 'TR',
    favoriteCountryIsoCodes: const ['TR', 'DE', 'GB'],
    labels: PhoneFieldLabels(pickerTitle: l10n.selectCountry, ...),
    fieldTheme: const PhoneFieldTheme(triggerBorderRadius: 12),
    pickerTheme: const PhoneCountryPickerTheme(showAlphabetIndex: false),
    child: child!,
  ),
)
```

A screen can override any of those inline, or replace the sheet entirely with
`countryPicker:`. `showPhoneCountryPicker(context, ...)` is also usable on its own.

Masks come from `flutter_multi_formatter`. To change one for the whole app, call
`PhoneInputFormatter.replacePhoneMask(countryCode: 'TR', newMask: '+00 000 000 00 00')`
during startup.

---

## 🧭 Routing arguments

One screen, several ways in: a list hands over the object, a push notification or
a deep link only an id. Casting `state.extra` breaks on the second caller.

Declare one strategy per source and let the factory pick:

```dart
final orderArgs = ViewArgsFactory<Order>([
  // First: an object already in hand must never cost a request.
  const PassThroughResolver<Order>(),
  OrderByIdResolver(),
]);

GoRoute(
  path: '/order',
  builder: (context, state) => CustomFutureBuilder<Order>(
    future: orderArgs.resolve(state.extra),
    builder: (context, order) => OrderView(order: order),
    errorBuilder: (context, _) => const OrderListView(),
  ),
);
```

A resolver answers two questions:

```dart
class OrderByIdResolver extends ViewArgsResolver<Order> {
  @override
  bool canResolve(Object? input) =>
      input is Map && input['orderId'] is String;

  @override
  Future<Order> resolve(Object? input) => api.getOrder(input['orderId']);
}
```

Order matters — the first resolver that says `canResolve` wins. When nothing
matches, `resolve` fails with `ViewArgsUnresolved`, or use `resolveOr` to fall
back. `ViewArgsUnresolved` names the **types** involved and never the value: a
route argument can be user data and error messages reach the logs.

For a one-off there is `InlineViewArgsResolver`, which takes the two callbacks
directly instead of a subclass.
