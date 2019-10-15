//
//  HomeButtonStreamHandler.swift
//  hardware_buttons
//
//  Created by 양어진 on 03/10/2019.
//

import Foundation

public class HomeButtonStreamHandler: NSObject, FlutterStreamHandler, HomeListener {
    
    private var eventSink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        singleHomeAndLockObserver.addHomeListener(listener: self)
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        singleHomeAndLockObserver.removeHomeListener(listener: self)
        return nil
    }
    
    func onEvent() {
        self.eventSink?(0)
    }
}
