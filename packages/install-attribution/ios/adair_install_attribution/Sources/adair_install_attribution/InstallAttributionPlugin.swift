import Flutter
import StoreKit
import UIKit

public class InstallAttributionPlugin: NSObject, FlutterPlugin {
  private static let channelInstallAttribution = "adair_install_attribution"
  private static let methodRegister = "register"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: channelInstallAttribution,
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(InstallAttributionPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case InstallAttributionPlugin.methodRegister:
      registerInstallAttribution(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Registers the install with SKAdNetwork so Apple sends the install
  /// postback to the ad network (Meta) that drove it. No IDFA or ATT prompt
  /// is involved.
  private func registerInstallAttribution(result: @escaping FlutterResult) {
    if #available(iOS 16.1, *) {
      SKAdNetwork.updatePostbackConversionValue(0, coarseValue: .low, lockWindow: false) { error in
        InstallAttributionPlugin.complete(
          result: result,
          error: error,
          path: "SKAdNetwork.updatePostbackConversionValue(_:coarseValue:lockWindow:) (iOS 16.1+)"
        )
      }
    } else {
      SKAdNetwork.updatePostbackConversionValue(0) { error in
        InstallAttributionPlugin.complete(
          result: result,
          error: error,
          path: "SKAdNetwork.updatePostbackConversionValue(_:) (iOS 15.4+)"
        )
      }
    }
  }

  /// Completes `result` with `path`, a description of the API that was called,
  /// so Dart can log which code path was taken.
  private static func complete(result: @escaping FlutterResult, error: Error?, path: String) {
    DispatchQueue.main.async {
      if let error = error {
        result(FlutterError(
          code: "register_failed",
          message: error.localizedDescription,
          details: nil
        ))
      } else {
        result(path)
      }
    }
  }
}
