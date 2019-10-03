//
//  VolumeButtenStreamHandler.swift
//  hardware_buttons
//
//  Created by 양어진 on 03/10/2019.
//

import Foundation
import AVFoundation

public class VolumeButtenStreamHandler: NSObject, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    private var volumeLevel: Float = 0.0
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
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
