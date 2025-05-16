import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1. First, we have obtained the FlutterViewController controller in order to access binaryMessenger.
    let controller = FlutterViewController = window?.rootViewController as! FlutterViewController

    // 2. Next, we have created an instance of MethodChannel. Once again, the name should completely
    // match the one defined on the Flutter side.
    let favoriteChannel = FlutterMethodChannel(
      name: "com.example.candy_store/favorite",
      binaryMessenger: controller.binaryMessenger
    )

    // 3. After that, we set the method handler on the channel, where we match strings as method names, as before.
    favoriteChannel.setMethodCallHandler { [weak self] (
      call: FlutterMethodCall,
      result: @escaping FlutterResult) in guard let self =
      self else { return }
      switch call.method {
        case "getFavorite":
          result(self.getFavorite())
        case "addFavorite":
          // 4. Similar to Kotlin, we have unwrapped potentially nullable arguments
          // and implemented error handling for invalid argument cases.
          //! This means if we can safely cast call.arguments to be a map of type [String: Any],
          //! and this map contains a String value with the "id" key,
          //! then execute the following block of code. Otherwise, execute the else code block.
          if let args = call.arguments as? [String: Any],
            let id = args["id"] as? String {
              self.toggleFavorite( id, isFavorite: true)
              result(true)
          } else {
            result(FlutterError(
              code: "INVALID_ARGUMENT",
              message: "id is null",
              details: nil)
            )
          }
        default:
        // 5. Finally, we have returned a result, which can be nil or values
        // (such as in getFavorite) indicating success, FlutterError in case of an error,
        // or FlutterMethodNotImplemented if we don't know how to handle the method.
          result(FlutterMethodNotImplemented)
      }
    }


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
