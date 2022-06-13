//
//  ViewController.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/26.
//

import Cocoa
import SwiftUI
import Masonry

//import lyData

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = LYPasterMonitor.shareInstance()
        
//        var lll:LYWCustomWebview = LYWCustomWebview()
//        lll.frame = NSRect.init(x: 10, y: 200, width: 400, height: 600);
//        lll.layer?.backgroundColor = NSColor.red.cgColor
//        self.view.addSubview(lll)
//
//        let path = LYPasterMonitor.pasteRootPath().appending("/001.rtf")
//
////        lll.urlStr = "https://blog.csdn.net/qq_36924683/article/details/121198340"
//        lll.url = URL.init(fileURLWithPath: path)
//
//        let textView = NSTextView.init(frame: NSRect.init(x: 0, y: 0, width: 400, height: 300))
//        self.view.addSubview(textView)
//        do{
////            let text = try String.init(contentsOfFile: path, encoding: .utf8)
////            textView.string = text
//            let dd = try Data.init(contentsOf: URL.init(fileURLWithPath: path))/Users/liukuiqing/Downloads/iOSAssetExtractor.html
////            textView.attributedString = NSAttributedString.init(rtf: dd, documentAttributes: nil)
//            textView.readRTFD(fromFile: path)
//        } catch let lerror {
//            print("str rtf failed: \(lerror)")
//        }
        // Do any additional setup after loading the view.
        
//        StatusBarController.init()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func stateACtion(_ sender: Any) {
//        let _ =  NSWindowController();
//        debugPrint("\(NSApplication.shared.windows)")
//        var rect = NSScreen.main?.frame ?? NSMakeRect(0, 0, 640, 480)
//        rect = NSRect(x: 0, y: 0, width: rect.width, height: 200)
//        let window = NSWindow(contentRect: rect,
//                             styleMask: [],
//                             backing: .buffered,
//                              defer: false, screen: NSScreen.main)
//        window.backgroundColor = .gray
//        window.level = NSWindow.Level.floating
//        window.isMovableByWindowBackground = true
//        
//        let view = NSView(frame: NSRect(x: 0, y: 0, width: rect.width, height: rect.height))
//        let layer = CALayer()
//        view.wantsLayer = true
//        view.layer = layer
//        view.layer?.backgroundColor = NSColor.red.cgColor
//        /// todo : 此处将显示的view赋值给contentView
//        window.contentView = view
//        self.window = window
//        window.orderFront(window)
//        NSApplication.shared.runModal(for: window)
    }
    
}

