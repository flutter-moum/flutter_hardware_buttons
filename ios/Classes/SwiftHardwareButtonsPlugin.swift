import Flutter
import UIKit
import AVFoundation

enum ChannelName {
    static let volume = "flutter.moum.hardware_buttons.volume"
}

public class SwiftHardwareButtonsPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var volumeLevel: Float = 0.0
    var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftHardwareButtonsPlugin()
        
        // VolumeButton
        let volumeStream = FlutterEventChannel(name: ChannelName.volume,
                                               binaryMessenger: registrar.messenger())
        volumeStream.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall,
                       result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    public func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
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
        return nil
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.outputVolume > volumeLevel {
                eventSink?(24)
            }
            if audioSession.outputVolume < volumeLevel {
                eventSink?(25)
            }
            volumeLevel = audioSession.outputVolume
        }
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self,
                                                  forKeyPath: "outputVolume")
        eventSink = nil
        return nil
    }
}
