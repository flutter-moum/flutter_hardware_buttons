//
//  LockButtonStreamHandler.swift
//  hardware_buttons
//
//  Created by 양어진 on 08/10/2019.
//

import Foundation

public class LockButtonStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?
    private let notificationCenter = NotificationCenter.default
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        registerLockObserver()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        removeLockObserver()
        return nil
    }
    
    // Register Lock Notification
    private func registerLockObserver() {
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            Unmanaged.passUnretained(self).toOpaque(),
            displayStatusChangedCallback,
            "com.apple.springboard.lockstate" as CFString,
            nil,
            .deliverImmediately)
    }
    
    // Remove Lock Notification
    private func removeLockObserver() {
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
                                           Unmanaged.passUnretained(self).toOpaque(),
                                           nil,
                                           nil)
    }
    
    private func displayStatusChanged(_ lockState: String) {
        if lockState == "com.apple.springboard.lockstate" {
            eventSink?(0)
        }
    }
    
    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        
        let catcher = Unmanaged<LockButtonStreamHandler>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
        catcher.displayStatusChanged(lockState)
    }
}
