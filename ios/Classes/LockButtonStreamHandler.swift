//
//  LockButtonStreamHandler.swift
//  hardware_buttons
//
//  Created by 양어진 on 08/10/2019.
//

import Foundation

public class LockButtonStreamHandler: NSObject, FlutterStreamHandler, LockListener {
    
    private var eventSink: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        singleHomeAndLockObserver.addLockListener(listener: self)
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        singleHomeAndLockObserver.removeLockListener(listener: self)
        eventSink = nil
        return nil
    }
    
    func onEvent() {
        self.eventSink?(0)
    }
}
