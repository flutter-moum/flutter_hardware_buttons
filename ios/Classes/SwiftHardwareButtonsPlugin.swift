import Flutter
import UIKit
import AVFoundation

public class SwiftHardwareButtonsPlugin: NSObject, FlutterPlugin {

    private var volumeLevel: Float = 0.0
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let volumeChannel = FlutterMethodChannel(name: "hardware_buttons",
                                                 binaryMessenger: registrar.messenger())
        let instance = SwiftHardwareButtonsPlugin()
        registrar.addMethodCallDelegate(instance, channel: volumeChannel)
    }

    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    override init() {
        super.init()
        volumeChangeDetect()
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume"{
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.outputVolume > volumeLevel {
                showSimpleAlert(title: "Volume Up Button",
                                message: String(volumeLevel))
            }
            if audioSession.outputVolume < volumeLevel {
                showSimpleAlert(title: "Volume Down Button",
                                message: String(volumeLevel))
            }
            volumeLevel = audioSession.outputVolume
        }
    }
    
    private func volumeChangeDetect() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self,
                                     forKeyPath: "outputVolume",
                                     options: .new,
                                     context: nil)
            volumeLevel = audioSession.outputVolume
        } catch {
            print("error")
        }
    }
    
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: nil))
        UIApplication.shared
            .keyWindow?.rootViewController?.present(alert,
                                                    animated: true,
                                                    completion: nil)
    }

}
