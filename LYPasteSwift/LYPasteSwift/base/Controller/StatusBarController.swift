//
//  StatusBarController.swift
//  LYPasteSwift
//
//  Created by user on 2022/4/30.
//

import Foundation
import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var eventMonitor: EventMonitor?
    private var window: NSWindow?
    
    init() {
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            
            statusBarButton.action = #selector(toggleWindow(sender:))
            statusBarButton.target = self
        }
        
//        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown, .swipe, .beginGesture, .keyDown, .scrollWheel, .flagsChanged], handler: mouseEventHandler)
        self.bindEvent()
    }
    
    @objc func toggleWindow(sender: AnyObject) {
        if let _ = window {
            hideWindow(sender)
        }
        else {
            showWindow(sender)
        }
    }
    
    func showWindow(_ sender: AnyObject) {
        if let _ = statusItem.button {
            eventMonitor?.start()
            let _ =  NSWindowController();
            debugPrint("\(NSApplication.shared.windows)")
            var rect = NSScreen.main?.frame ?? NSMakeRect(0, 0, 640, 480)
            rect = NSRect(x: 0, y: 0, width: rect.width, height: 350)
            let window = NSWindow(contentRect: rect,
                                 styleMask: [],
                                 backing: .buffered,
                                  defer: false, screen: NSScreen.main)
            window.backgroundColor = .gray
            window.level = NSWindow.Level.floating
            window.isMovableByWindowBackground = true
            
            let view = NSView(frame: NSRect(x: 0, y: 0, width: rect.width, height: rect.height))
            let layer = CALayer()
            view.wantsLayer = true
            view.layer = layer
            view.layer?.backgroundColor = NSColor.red.cgColor
            /// todo : 此处将显示的view赋值给contentView
            let listview =  LYPasteListView.init(frame: NSRect.init(x: 0, y: 0, width: rect.width, height: rect.height))
//            self.view.addSubview(listview)
//            listview.mas_makeConstraints { make in
//                make?.center.equalTo()(self.view)
//                make?.width.equalTo()(self.view)
//                make?.width.mas_greaterThanOrEqualTo()(500)
//                make?.height.mas_equalTo()(300)
//                make?.height.lessThanOrEqualTo()(self.view)
//            }
            window.contentView = listview
            listview.listView.reloadData()
            LYPasterData.instance.createTable(table: TestTableModel.tabName, of: TestTableModel.self)

            LYPasterMonitor.shareInstance().newPateFunc = listview as! LYBlock
            self.window = window
//            NSApplication.shared.windows.last?.orderFront(window)
//            window.orderFront(NSApplication.shared.windows.last)
//            window.level = NSWindow.Level.init(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.overlayWindow)))
            window.orderFront(window)
            NSApplication.shared.runModal(for: window)
//            NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
//            window.beginSheet(window) { responseCode in
//                debugPrint("\(responseCode)")
//            }
//            NSApp.beginModalSession(for: window)
        }
    }
    
    func hideWindow(_ sender: AnyObject) {
        eventMonitor?.stop()
        self.window?.orderOut(self.window)
        self.window = nil
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if let _ = window {
            hideWindow(event!)
        }
    }
//    var commandPress = false
    var controlPress = false
    var shiftPress = false
}
//监听快捷键
extension StatusBarController{
    func bindEvent() {
        NSEvent.addGlobalMonitorForEvents(matching: [.keyUp,NSEvent.EventTypeMask.flagsChanged]) { event in
            let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
            switch flags {
//            case [.command]:
//                self.commandPress = true
            case [.shift]:
                self.shiftPress = true
//            case [.command,.shift]:
//                self.commandPress = true
//                self.shiftPress = true
            case [.control]:
                self.controlPress = true
            case [.control,.shift]:
                self.controlPress = true
                self.shiftPress = true
            case [NSEvent.ModifierFlags.init(rawValue: 0)]:
//                self.commandPress = false
                self.controlPress = false
                self.shiftPress = false
            default:
                if flags.contains(.shift){
                    self.shiftPress = true
                }
                if flags.contains(.control){
                    self.controlPress = true
                }
                print("other")
                break
            }
            self.checkShowState()
            print("flags \(flags) ")
        }
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown,.rightMouseDown,.swipe]) { event in
            let flags = event.modifierFlags.intersection(NSEvent.ModifierFlags.deviceIndependentFlagsMask)
            self.hideWindow(self)
            print("click \(flags) ")
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
        var d = Keylogger()
        d.start()
        funcPy()
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
    func funcPy(){
        let emailTask = Process.init();
        let path = Bundle.main.path(forResource: "pyLogger.py", ofType: nil)
        let pyStr = String.init(format:"python %@",path!)
        //这个不好用
        //    [emailTask setLaunchPath:@"/usr/bin/python"];
        //    [emailTask setArguments:[NSArray arrayWithObjects:@"-x86_64",pyStr, nil]];
//        emailTask setLaunchPath:@"/bin/bash"];
        emailTask.launchPath = "/bin/bash"
//        emailTask.launchPath = "/usr/bin/python3"
        emailTask.arguments = ["-c",pyStr]
        let pipe = Pipe.init()
        emailTask.standardOutput = pipe
        emailTask.standardError = pipe;
        do {
            emailTask.launch()
            emailTask.waitUntilExit()
        } catch  let error {
            print("python error: \(error)")
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let strReturnFromPython = String.init(data: data, encoding: .utf8)
        NSLog("python log:%@",strReturnFromPython ?? "");
    }
}
