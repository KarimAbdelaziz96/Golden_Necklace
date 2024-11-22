import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // إعداد قناة MethodChannel
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "main_activity_channel",
                binaryMessenger: controller.binaryMessenger
            )
            
            channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "getData" {
                    // هنا يمكنك وضع البيانات التي تريد إرسالها
                    let data = "iOS Native Data" // يمكنك تغيير هذه القيمة لبيانات أخرى
                    result(data)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
