//
//  ViewController.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/26.
//

import Cocoa

import lyData

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lll:LYWCustomWebview = LYWCustomWebview()
        lll.frame = NSRect.init(x: 0, y: 0, width: 400, height: 1000);
        lll.layer?.backgroundColor = NSColor.red.cgColor
        self.view.addSubview(lll)
        lll.urlStr = "https://blog.csdn.net/qq_36924683/article/details/121198340"
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

