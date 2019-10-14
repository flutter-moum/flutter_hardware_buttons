//
//  HomeButtonStreamHandler.swift
//  hardware_buttons
//
//  Created by 양어진 on 03/10/2019.
//

import Foundation

public class HomeButtonStreamHandler: NSObject, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    private let notificationCenter = NotificationCenter.default
    private var homeTask: DispatchWorkItem?
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        registerHomeObserver()
        registerLockObserver()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        removeHomeObserver()
        removeLockObserver()
        return nil
    }
    
    // Register Home Notification
    private func registerHomeObserver() {
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: Notification.Name.UIApplicationWillResignActive,
            object: nil)
    }
    
    // Register Lock Notification
    private func registerLockObserver() {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            Unmanaged.passUnretained(self).toOpaque(),
            displayStatusChangedCallback,
            "com.apple.springboard.lockcomplete" as CFString,
            nil,
            .deliverImmediately)
    }
    
    // Remove Home Notification
    private func removeHomeObserver() {
        notificationCenter.removeObserver(Notification.Name.UIApplicationWillResignActive)
    }

    // Remove Lock Notification
    private func removeLockObserver() {
        CFNotificationCenterRemoveObserver(
            CFNotificationCenterGetLocalCenter(),
            Unmanaged.passUnretained(self).toOpaque(),
            nil,
            nil)
    }
    
    // Home Button Detection
    @objc func applicationWillResignActive(){
        homeTask = DispatchWorkItem {
            print("HOME")
        }
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + 0.2,
            execute: homeTask ?? DispatchWorkItem(block: {
                print("error")
            }))
    }
    
    // Lock Button Detection
    private func displayStatusChanged(_ lockState: String) {
        if lockState == "com.apple.springboard.lockcomplete" {
            print("LOCK")
            homeTask?.cancel()
//            eventSink?(0)
        }
    }
    
    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        
        let catcher = Unmanaged<HomeButtonStreamHandler>
            .fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!))
            .takeUnretainedValue()
        catcher.displayStatusChanged(lockState)
    }
}
