//
//  SingleHomeAndLockObserver.swift
//  hardware_buttons
//
//  Created by 양어진 on 15/10/2019.
//

import Foundation

protocol LockListener {
    func onEvent()
}

protocol HomeListener {
    func onEvent()
}

let singleHomeAndLockObserver = SingleHomeAndLockObserver()

class SingleHomeAndLockObserver {

    private var lockListener: LockListener?
    private var homeListener: HomeListener?
    
    private let notificationCenter = NotificationCenter.default
    private var homeTask: DispatchWorkItem?
    
    // Add Lock Listener
    public func addLockListener(listener: LockListener) {
        if lockListener == nil {
            lockListener = listener
            if homeListener == nil {
                registerObserver()
            }
        }
    }
    
    // Remove Lock Listener
    public func removeLockListener(listener: LockListener) {
        lockListener = nil
        if homeListener == nil {
            unregisterObserver()
        }
    }
    
    // Add Home Listener
    public func addHomeListener(listener: HomeListener) {
        if homeListener == nil {
            homeListener = listener
            if lockListener == nil {
                registerObserver()
            }
        }
    }
    
    // Remove Home Listener
    public func removeHomeListener(listener: HomeListener) {
        homeListener = nil
        if lockListener == nil {
            unregisterObserver()
        }
    }
    
    private func registerObserver() {
        // Lock Button
        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            Unmanaged.passUnretained(self).toOpaque(),
            displayStatusChangedCallback,
            "com.apple.springboard.lockcomplete" as CFString,
            nil,
            .deliverImmediately)
        
        // Home Button
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil)
    }
    
    private func unregisterObserver() {
        // Lock Button
        CFNotificationCenterRemoveObserver(
            CFNotificationCenterGetLocalCenter(),
            Unmanaged.passUnretained(self).toOpaque(),
            nil,
            nil)
        
        // Home Button
        notificationCenter.removeObserver(self,
                                          name: UIApplication.willResignActiveNotification,
                                          object: nil)
    }
    
    // Lock Button Detection
    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        
        let catcher = Unmanaged<SingleHomeAndLockObserver>
            .fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!))
            .takeUnretainedValue()
        catcher.displayStatusChanged(lockState)
    }
    
    func displayStatusChanged(_ lockState: String) {
        if lockState == "com.apple.springboard.lockcomplete" {
            homeTask?.cancel()
            lockListener?.onEvent()
        }
    }
    
    // Home Button Detection
    @objc func applicationWillResignActive(){
        homeTask = DispatchWorkItem {
            self.homeListener?.onEvent()
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + 0.5,
            execute: homeTask ?? DispatchWorkItem(block: {
                print("error")
            }))
        
    }
}
