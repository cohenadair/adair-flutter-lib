import 'package:quiver/strings.dart';

import 'log.dart';

class PropertiesFile {
  final _log = const Log("PropertiesFile");

  final Map<String, String> _properties = {};

  PropertiesFile(String? propertiesString) {
    if (isEmpty(propertiesString)) {
      return;
    }

    try {
      propertiesString!.split("\n").forEach((line) {
        var pair = line.split("=");
        if (pair.length != 2) {
          return;
        }
        if (isNotEmpty(pair.last)) {
          _properties[pair.first] = pair.last;
        }
      });
    } on Exception catch (e) {
      _log.e(e, reason: "Loading properties file");
    }
  }

  String stringForKey(String key) {
    assert(_properties.containsKey(key));
    return _properties[key]!;
  }
}
