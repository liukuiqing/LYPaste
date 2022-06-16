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
    private var windowController: NSWindowController?
    private var isHidden = true
    
    init() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc public func toggleWindow() {
        if  !isHidden {
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
        if self.window == nil {
            let window = LYPasterWindow.init(contentRect: rect, styleMask: [], backing: .buffered, defer: true, screen: NSScreen.main)
            window.backgroundColor = .windowBackgroundColor
            window.level = NSWindow.Level.popUpMenu
            window.isMovableByWindowBackground = false
            self.window = window
            let wc: NSWindowController = NSWindowController.init(window: window)
            wc.loadWindow()
        }
        /// todo : 此处将显示的view赋值给contentView
        let listview =  LYPasteListView.init(frame: NSRect.init(x: 0, y: 18, width: rect.width, height: 295))
        listview.voidBlock()
        LYPasterData.instance.createTable(table: TestTableModel.tabName, of: TestTableModel.self)
        LYPasterMonitor.shareInstance().newPateFunc = listview
        self.window?.contentView = listview
        self.window?.makeKeyAndOrderFront(window)
        isHidden = false
    }
    
    public func hideWindow() {
        eventMonitor?.stop()
        self.window?.orderOut(self.window)
        self.window?.contentView = nil
        NSApplication.shared.stopModal()
        LYPasterMonitor.shareInstance().searhKey = nil
        isHidden = true
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if let _ = window {
            hideWindow()
        }
    }
}
