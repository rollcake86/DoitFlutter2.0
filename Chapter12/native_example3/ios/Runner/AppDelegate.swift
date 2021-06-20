import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    
          let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(name: "com.flutter.dev/calc" , binaryMessenger: controller.binaryMessenger)
          
          nativeChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              nativeChannel.setMethodCallHandler({
                  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                  guard call.method == "add" else {
                      result(FlutterMethodNotImplemented)
                      return
                  }
                  
                  if(call.method == "add"){
                      let array : Array = call.arguments as! Array<Int>
                      let sum = array[0] + array[1]
                      self?.sendNativeCalc(result: result , calcResult: sum)
                  }
              })
          })

    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    private func sendNativeCalc(result: FlutterResult , calcResult : Int) {
       result(calcResult)
    }

}
