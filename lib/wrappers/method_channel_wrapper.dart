import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Wraps [MethodChannel] construction. [MethodChannel] itself is mockable
/// (it has no `final`/`sealed` class modifier, so `implements MethodChannel`
/// works fine in a generated mock), but a call site that constructs one
/// directly — `const MethodChannel("...")` — has no seam for a test to
/// substitute a mock instance. Route construction through [channel] instead.
class MethodChannelWrapper {
  static var _instance = MethodChannelWrapper._();

  static MethodChannelWrapper get get => _instance;

  @visibleForTesting
  static void set(MethodChannelWrapper wrapper) => _instance = wrapper;

  @visibleForTesting
  static void reset() => _instance = MethodChannelWrapper._();

  MethodChannelWrapper._();

  MethodChannel channel(String name) => MethodChannel(name);
}
