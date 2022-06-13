//
//  AppDelegate.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/26.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    public var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBar = StatusBarController.init()
        let _ = LYPasterMonitor.shareInstance()
        LYPasterHotKey.setupHotKey()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

