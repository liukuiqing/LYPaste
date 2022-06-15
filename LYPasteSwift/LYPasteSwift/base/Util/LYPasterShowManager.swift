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
        showPasteVC()
    }
    
    func showPasteVC() {
        var rect = NSScreen.main?.frame ?? NSMakeRect(0, 0, 640, 480)
        rect = NSRect(x: 0, y: 0, width: rect.width, height: 350)
        let window = LYPasterWindow.init(contentRect: rect, styleMask: [], backing: .buffered, defer: true, screen: NSScreen.main)
        window.backgroundColor = .windowBackgroundColor
        window.level = NSWindow.Level.popUpMenu
        window.isMovableByWindowBackground = false
        
        /// todo : 此处将显示的view赋值给contentView
        let listview =  LYPasteListView.init(frame: NSRect.init(x: 0, y: 18, width: rect.width, height: 295))
        window.contentView = listview
        listview.voidBlock()
        LYPasterData.instance.createTable(table: TestTableModel.tabName, of: TestTableModel.self)
        LYPasterMonitor.shareInstance().newPateFunc = listview
        self.window = window
        let wc: NSWindowController = NSWindowController.init(window: window)
        wc.window?.contentView = listview
        wc.window?.makeKeyAndOrderFront(window)
        wc.showWindow(listview)
        wc.loadWindow()
    }
    
    public func hideWindow() {
        eventMonitor?.stop()
        self.window?.orderOut(self.window)
        NSApplication.shared.stopModal()
        self.window = nil
        LYPasterMonitor.shareInstance().searhKey = nil
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if let _ = window {
            hideWindow()
        }
    }
}
