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
    private var isObserving: Bool = false
    private let notificationCenter = NotificationCenter.default
    private let audioSession = AVAudioSession.sharedInstance()
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        registerVolumeObserver()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        removeVolumeObserver()
        return nil
    }
    
    // Register Volume Notification
    private func registerVolumeObserver() {
        activateAudioSession()
        notificationCenter.addObserver(
            self,
            selector: #selector(activateAudioSession),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    // Remove Volume Notification
    private func removeVolumeObserver() {
        audioSession.removeObserver(self,
                                    forKeyPath: "outputVolume")
        notificationCenter.removeObserver(self,
                                          name: UIApplication.didBecomeActiveNotification,
                                          object: nil)
    }
    
    @objc func activateAudioSession(){
        do {
            try audioSession.setCategory(AVAudioSession.Category.ambient)
            try audioSession.setActive(true)
            if !isObserving {
                audioSession.addObserver(self,
                                         forKeyPath: "outputVolume",
                                         options: .new,
                                         context: nil)
                isObserving = true
            }
            volumeLevel = audioSession.outputVolume
        } catch {
            print("error")
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume" {
            if audioSession.outputVolume > volumeLevel {
                eventSink?(24)
            }
            if audioSession.outputVolume < volumeLevel {
                eventSink?(25)
            }
            volumeLevel = audioSession.outputVolume
        }
    }
}
