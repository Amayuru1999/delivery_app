import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // TODO: Replace with your Google Maps API key
    // Get your key from: https://console.cloud.google.com/google/maps-apis
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")

  
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}