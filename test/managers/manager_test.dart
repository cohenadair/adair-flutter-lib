import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestManager extends Manager {
  @override
  Future<void> init() async {}
}

void main() {
  test("onSignOut completes without doing anything by default", () async {
    await expectLater(_TestManager().onSignOut(), completes);
  });
}
