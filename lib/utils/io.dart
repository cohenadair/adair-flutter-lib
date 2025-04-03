import '../wrappers/io_wrapper.dart';

Future<bool> isConnected() async {
  /// A quick DNS lookup will tell us if there's a current internet
  /// connection. An "example.com" lookup doesn't always work on iOS, so
  /// use Google as a backup.
  return (await IoWrapper.get.lookup("example.com")).isNotEmpty ||
      (await IoWrapper.get.lookup("google.com")).isNotEmpty;
}
