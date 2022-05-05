//
//  LYPasterShowManager.swift
//  LYPasteSwift
//
//  Created by user on 2022/5/5.
//

import Cocoa

class LYPasterShowManager {
    static let instance = LYPasterShowManager()
    private var eventMonitor: EventMonitor?
    private var window: NSWindow?
    
    init() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc public func toggleWindow() {
        if let _ = window {
            hideWindow()
        }
        else {
            showWindow()
        }
    }

    public func showWindow() {
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
            let listview =  LYPasteListView.init(frame: NSRect.init(x: 0, y: 18, width: rect.width, height: 295))
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
//            NSApplication.shared.runModal(for: window)
//            NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
//            window.beginSheet(window) { responseCode in
//                debugPrint("\(responseCode)")
//            }
//            NSApp.beginModalSession(for: window)
    }
    
    public func hideWindow() {
        eventMonitor?.stop()
        self.window?.orderOut(self.window)
        NSApplication.shared.stopModal()
        self.window = nil
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if let _ = window {
            hideWindow()
        }
    }
}
