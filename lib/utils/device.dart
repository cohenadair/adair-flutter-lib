import 'package:adair_flutter_lib/wrappers/io_wrapper.dart';

import '../wrappers/device_info_wrapper.dart';

Future<bool> hasDynamicIsland() async {
  if (IoWrapper.get.isAndroid) {
    return false;
  }

  final islandModels = [
    "iPhone15,2", // 14 Pro
    "iPhone15,3", // 14 Pro Max

    "iPhone15,4", // 15
    "iPhone15,5", // 15 Plus
    "iPhone16,1", // 15 Pro
    "iPhone16,2", // 15 Pro Max

    "iPhone17,1", // 16 Pro
    "iPhone17,2", // 16 Pro Max
    "iPhone17,3", // 16
    "iPhone17,4", // 16 Plus
    "iPhone17,5", // 16e

    "iPhone18,1", // 17 Pro
    "iPhone18,2", // 17 Pro Max
    "iPhone18,3", // 17
    "iPhone18,4", // iPhone Air
  ];

  return islandModels.contains(
    (await DeviceInfoWrapper.get.iosInfo).data["utsname"]["machine"],
  );
}
