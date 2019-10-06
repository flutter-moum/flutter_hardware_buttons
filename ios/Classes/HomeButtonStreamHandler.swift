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
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: Notification.Name.UIApplicationWillResignActive,
            object: nil)
        return nil
    }
    
    @objc func applicationWillResignActive(){
        print("out of focus!")
        eventSink?(0)
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        notificationCenter.removeObserver(Notification.Name.UIApplicationWillResignActive)
        eventSink = nil
        return nil
    }
}
