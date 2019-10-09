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
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        registerHomeObserver()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        removeHomeObserver()
        return nil
    }
    
    // Register Home Notification
    private func registerHomeObserver() {
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: Notification.Name.UIApplicationDidEnterBackground,
            object: nil)
    }
    
    // Remove Home Notification
    private func removeHomeObserver() {
        notificationCenter.removeObserver(Notification.Name.UIApplicationDidEnterBackground)
    }
    
    @objc func applicationDidEnterBackground(){
        print("out of focus!")
        eventSink?(0)
    }
}
