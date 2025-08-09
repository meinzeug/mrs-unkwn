import Flutter
import UIKit
import FamilyControls

@available(iOS 16.0, *)
class DeviceMonitoringPlugin: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.mrsunkwn/device_monitoring",
                                           binaryMessenger: registrar.messenger())
        let instance = DeviceMonitoringPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasPermission":
            result(hasAuthorization())
        case "requestPermission":
            Task {
                do {
                    try await requestAuthorization()
                    result(nil)
                } catch {
                    result(FlutterError(code: "AUTH_ERROR", message: error.localizedDescription, details: nil))
                }
            }
        case "openPermissionSettings":
            if let url = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            result(nil)
        case "getAppUsageStats":
            Task {
                await self.getAppUsageStats(result: result)
            }
        case "startMonitoring", "stopMonitoring", "getInstalledApps":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func hasAuthorization() -> Bool {
        AuthorizationCenter.shared.authorizationStatus == .approved
    }

    private func requestAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    private func getAppUsageStats(result: @escaping FlutterResult) async {
        do {
            try await requestAuthorization()
            // TODO: Implement real Screen Time data retrieval using DeviceActivity API
            result([])
        } catch {
            result(FlutterError(code: "AUTH_ERROR", message: error.localizedDescription, details: nil))
        }
    }
}
