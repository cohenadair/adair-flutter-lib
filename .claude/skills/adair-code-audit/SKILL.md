---
name: adair-code-audit
description: >
  adair-flutter-lib-specific additions to the root adair-code-audit skill
  (Flutter code review / pre-commit checklist). Same triggers as the root
  skill; always follow the root skill first, then apply these lib rules.
---

# adair-code-audit — adair-flutter-lib additions

**This file is not a standalone skill.** Read and follow the root skill at
`/Users/cohen/Documents/flutter-projects/.claude/skills/adair-code-audit/SKILL.md`,
and apply the additions below wherever adair-flutter-lib is in scope.

## Step 1 — Scope

- The Flutter root is `adair-flutter-lib/`.

## Step 6 — Tests for nested packages (`packages/*`)

- A nested package (e.g. `packages/install-attribution`) has its own
  gitignored `pubspec.lock`, which can resolve newer transitive versions
  (e.g. `cloud_firestore`) than the lib's. Importing the lib's
  `test/mocks/mocks.mocks.dart` or `StubbedManagers` from there then fails to
  compile. For a manager that only talks to a method channel, use the real
  `MethodChannelWrapper` plus
  `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
  .setMockMethodCallHandler(...)` instead of the lib's mocks.
- The lib's `analysis_options.yaml` excludes `packages/**`; run `flutter
  analyze` / `flutter test` from the package directory itself.

## Step 5 / Step 8 — Regenerating mocks

- Regenerate stale mocks with `dart run build_runner build` from
  `adair-flutter-lib/`. Never hand-edit `test/mocks/mocks.mocks.dart`.

## Step 10 — ARB locale rules

| Base | Requires full coverage | Skip (spelling variants only) |
|------|------------------------|-------------------------------|
| `lib/l10n/adair_flutter_lib_en.arb` | `adair_flutter_lib_es.arb` | `adair_flutter_lib_en_US.arb` |

```bash
diff \
  <(jq -r 'keys[] | select(startswith("@") | not)' adair-flutter-lib/lib/l10n/adair_flutter_lib_en.arb | sort) \
  <(jq -r 'keys[] | select(startswith("@") | not)' adair-flutter-lib/lib/l10n/adair_flutter_lib_es.arb | sort)
```
