import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppDelegate.disableFlutterViewFocusItems()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Workaround for a crash in the Flutter 3.29.3 engine on iOS/iPadOS 26:
  /// UIKit's focus system calls -[FlutterView focusItemsInRect:], which builds an
  /// NSArray containing nil and throws NSInvalidArgumentException, killing the app
  /// (seen on iPad within seconds of launch). The app doesn't use keyboard/pointer
  /// focus navigation, so FlutterView reports no focus items instead.
  /// Remove this once Flutter is upgraded to a version with the engine fix.
  private static func disableFlutterViewFocusItems() {
    guard let flutterViewClass = NSClassFromString("FlutterView") else { return }
    let selector = NSSelectorFromString("focusItemsInRect:")
    guard let method = class_getInstanceMethod(flutterViewClass, selector) else { return }
    let noFocusItems: @convention(block) (AnyObject, CGRect) -> NSArray = { _, _ in NSArray() }
    // class_replaceMethod only affects FlutterView, never UIView or other subclasses.
    class_replaceMethod(
      flutterViewClass,
      selector,
      imp_implementationWithBlock(noFocusItems),
      method_getTypeEncoding(method)
    )
  }
}
