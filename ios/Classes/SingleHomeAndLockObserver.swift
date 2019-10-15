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
    
    var lockListeners = [LockListener]()
    var homeListeners = [HomeListener]()
    
    private let notificationCenter = NotificationCenter.default
    private var homeTask: DispatchWorkItem?
    
    // Add Lock Listener
    public func addLockListener(listener: LockListener) {
        lockListeners.append(listener)
        if lockListeners.count + homeListeners.count == 1 {
            registerObserver()
        }
    }
    
    // Remove Lock Listener
    public func removeLockListener(listener: LockListener) {
        lockListeners.removeAll()
        if lockListeners.count == 0 && homeListeners.count == 0 {
            unregisterObserver()
        }
    }
    
    // Add Home Listener
    public func addHomeListener(listener: HomeListener) {
        homeListeners.append(listener)
        if lockListeners.count + homeListeners.count == 1 {
            registerObserver()
        }
    }
    
    // Remove Home Listener
    public func removeHomeListener(listener: HomeListener) {
        homeListeners.removeAll()
        if homeListeners.count == 0 || lockListeners.count == 0 {
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
            name: Notification.Name.UIApplicationWillResignActive,
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
        notificationCenter.removeObserver(
            Notification.Name.UIApplicationWillResignActive)
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
            for listener in lockListeners {
                listener.onEvent()
            }
        }
    }
    
    // Home Button Detection
    
    @objc func applicationWillResignActive(){
        for homeListener in homeListeners {
            homeTask = DispatchWorkItem {
                homeListener.onEvent()
            }
            
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + 0.2,
                execute: homeTask ?? DispatchWorkItem(block: {
                    print("error")
                }))
        }
    }
}
