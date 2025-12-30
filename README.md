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
  my_core:
    git:
      url: https://github.com/aga/my_core.git
      ref: main (or selected version tag, e.g. v0.0.1)