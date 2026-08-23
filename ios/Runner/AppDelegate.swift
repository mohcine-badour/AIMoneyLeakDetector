import Flutter
import UIKit
import UserNotifications
import Vision
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var receiptOcrChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "kichta/receipt_ocr",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      ReceiptOcr.handle(call, result: result)
    }
    receiptOcrChannel = channel
  }
}

private enum ReceiptOcr {
  static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "recognize" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "bad_args", message: "Missing arguments", details: nil))
      return
    }

    let cgImage: CGImage?
    if let path = args["path"] as? String, !path.isEmpty {
      cgImage = UIImage(contentsOfFile: path)?.cgImage
    } else if let data = args["bytes"] as? FlutterStandardTypedData {
      cgImage = UIImage(data: data.data)?.cgImage
    } else {
      cgImage = nil
    }

    guard let image = cgImage else {
      result(FlutterError(code: "bad_image", message: "Could not read the photo.", details: nil))
      return
    }

    recognize(image: image, result: result)
  }

  private static func recognize(image: CGImage, result: @escaping FlutterResult) {
    let request = VNRecognizeTextRequest { request, error in
      if let error {
        result(FlutterError(code: "ocr_failed", message: error.localizedDescription, details: nil))
        return
      }
      let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
      let lines = observations.compactMap { $0.topCandidates(1).first?.string }
      result(lines.joined(separator: "\n"))
    }
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try handler.perform([request])
      } catch {
        result(FlutterError(code: "ocr_failed", message: error.localizedDescription, details: nil))
      }
    }
  }
}
