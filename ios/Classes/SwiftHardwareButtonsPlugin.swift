import Flutter
import UIKit

enum ChannelName {
    static let volume = "flutter.moum.hardware_buttons.volume"
    static let home = "flutter.moum.hardware_buttons.home"
    static let lock = "flutter.moum.hardware_buttons.lock"
}

public class SwiftHardwareButtonsPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        // VolumeButton
        let volumeInstance = VolumeButtenStreamHandler()
        let volumeStream = FlutterEventChannel(name: ChannelName.volume,
                                               binaryMessenger: registrar.messenger())
        volumeStream.setStreamHandler(volumeInstance)
        
        // HomeButton
        let homeInstance = HomeButtonStreamHandler()
        let homeStream = FlutterEventChannel(name: ChannelName.home,
                                             binaryMessenger: registrar.messenger())
        homeStream.setStreamHandler(homeInstance)
        
        // LockButton
        let lockInstance = LockButtonStreamHandler()
        let lockStream = FlutterEventChannel(name: ChannelName.lock,
                                             binaryMessenger: registrar.messenger())
        lockStream.setStreamHandler(lockInstance)
        
    }

    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
    
}
