//
//  StatusBarController.swift
//  LYPasteSwift
//
//  Created by user on 2022/4/30.
//

import Foundation
import AppKit
import Cocoa
import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var eventMonitor: EventMonitor?
    private var window: NSWindow?
    private var popover: NSPopover

    init() {
        self.popover = NSPopover.init()
        let contentView = LYPasterPopoverView()
        popover.contentViewController = LYPasterPopoverController()
        popover.contentSize = NSSize(width: 100, height: 360)
        popover.contentViewController?.view = NSHostingView(rootView: contentView)

        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage.init(named: "StatusBarIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.alternateImage =  statusBarButton.image
            statusBarButton.highlight(true)
            statusBarButton.isTransparent = true
            
            statusBarButton.action = #selector(toggleWindow(sender:))
            statusBarButton.target = self
            statusBarButton.sendAction(on: [.leftMouseDown,.rightMouseDown])
        }
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc func toggleWindow(sender: AnyObject) {
        let btnMask = NSEvent.pressedMouseButtons
        let lDown = ((btnMask & (1<<0)) != 0)
//        var rDown = ((btnMask & (1<<0)) != 1)
        if lDown{
            LYPasterShowManager.instance.toggleWindow()
            hiddenPopover()
        }else{
            if !popover.isShown {
                if let statusBarButton = statusItem.button {
                    popover.show(relativeTo: statusBarButton.frame, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
                    eventMonitor?.start()
                }
            }else {
                hiddenPopover()
            }
        }
    }
    func mouseEventHandler(_ event: NSEvent?) {
        hiddenPopover()
    }
    
    public func hiddenPopover() {
        if popover.isShown {
            popover.performClose(nil)
            eventMonitor?.stop()
        }
    }

    var controlPress = false
    var shiftPress = false
}
//监听快捷键
extension StatusBarController {
    func bindEvent() {
//        NSEvent.addGlobalMonitorForEvents(matching: [.keyUp, NSEvent.EventTypeMask.flagsChanged]) { event in
//            let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
//            switch flags {
////            case [.command]:
////                self.commandPress = true
//            case [.shift]:
//                self.shiftPress = true
////            case [.command,.shift]:
////                self.commandPress = true
////                self.shiftPress = true
//            case [.control]:
//                self.controlPress = true
//
//            case [.control, .shift]:
//                self.controlPress = true
//                self.shiftPress = true
//
//            case [NSEvent.ModifierFlags.init(rawValue: 0)]:
////                self.commandPress = false
//                self.controlPress = false
//                self.shiftPress = false
//
//            default:
//                if flags.contains(.shift) {
//                    self.shiftPress = true
//                }
//                if flags.contains(.control) {
//                    self.controlPress = true
//                }
////                print("other")
//                break
//            }
//            self.checkShowState()
////            print("flags \(flags) ")
//        }
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .swipe]) { event in
//            let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
//            self.hideWindow(self)
//            print("click \(flags) ")
        }
//        NSEvent.addLocalMonitorForEvents(matching: [.keyDown,.keyUp]) { event in
//            print("down")
//            return event
//        }
//        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown,.keyUp]) { event in
//            print("down")
//        }
        
//        NSEvent.keyEvent(with: NSEvent.EventType.keyUp, location: NSPoint.init(), modifierFlags: [.command,.shift], timestamp: 0.1, windowNumber: 3, context: nil, characters: "c", charactersIgnoringModifiers: "'", isARepeat: true, keyCode: UInt16.init(10))
//        let evetTap:CFMachPort? = CGEvent.tapCreate(tap: .cghidEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: 1<<CGEventType.flagsChanged.rawValue, callback:{ proxy, type, event, refcon in
//            if (type != .keyDown) {
//                if (type != .keyUp) {
//                    if (type != .flagsChanged) {
//                        return Unmanaged.passRetained(event)
//                    }
//                }
//            }
//            return Unmanaged.passRetained(event)
//        }, userInfo: nil)
//        if evetTap != nil{
//            let runloopSource:CFRunLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, evetTap, 0)
//            CFRunLoopAddSource(CFRunLoopGetCurrent(),runloopSource,CFRunLoopMode.commonModes)
//            CGEvent.tapIsEnabled(tap: evetTap!)
//            CFRunLoopRun()
//        }
//        var d = Keylogger()
//        d.start()
//        funcPy()
    }

//    @convention(c) func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
//        if (type != .keyDown) {
//            if (type != .keyUp) {
//                if (type != .flagsChanged) {
//                    return Unmanaged.passRetained(event)
//                }
//            }
//        }
//        return Unmanaged.passRetained(event)
//    }
    func checkShowState() {
        if self.controlPress == true && self.shiftPress == true {
            if (self.window == nil) {
                toggleWindow(sender: self)
            }
        }
    }
//    func funcPy() {
//        let emailTask = Process.init();
//        let path = Bundle.main.path(forResource: "pyLogger.py", ofType: nil)
//        let pyStr = String.init(format: "python %@", path!)
//        //这个不好用
//        //    [emailTask setLaunchPath:@"/usr/bin/python"];
//        //    [emailTask setArguments:[NSArray arrayWithObjects:@"-x86_64",pyStr, nil]];
////        emailTask setLaunchPath:@"/bin/bash"];
//        emailTask.launchPath = "/bin/bash"
////        emailTask.launchPath = "/usr/bin/python3"
//        emailTask.arguments = ["-c", pyStr]
//        let pipe = Pipe.init()
//        emailTask.standardOutput = pipe
//        emailTask.standardError = pipe;
//        do {
//            emailTask.launch()
//            emailTask.waitUntilExit()
//        } catch  let error {
//            print("python error: \(error)")
//        }
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let strReturnFromPython = String.init(data: data, encoding: .utf8)
//        NSLog("python log:%@", strReturnFromPython ?? "");
//    }
}
