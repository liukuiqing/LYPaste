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
        
        LYPasterMonitor.shareInstance()
        
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
//            let dd = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
////            textView.attributedString = NSAttributedString.init(rtf: dd, documentAttributes: nil)
//            textView.readRTFD(fromFile: path)
//        } catch let lerror {
//            print("str rtf failed: \(lerror)")
//        }
        // Do any additional setup after loading the view.
        let listview =  LYPasteListView.init(frame: NSRect.init(x: 0, y: 0, width: 400, height: 300))
        self.view.addSubview(listview)
        listview.mas_makeConstraints { make in
            make?.center.equalTo()(self.view)
            make?.width.equalTo()(self.view)
            make?.width.mas_greaterThanOrEqualTo()(500)
            make?.height.mas_equalTo()(300)
            make?.height.lessThanOrEqualTo()(self.view)
        }
        listview.listView.reloadData()
        LYPasterData.instance.createTable(table: TestTableModel.tabName, of: TestTableModel.self)
//        bind()
//    }
//    func bind() -> Void {
        LYPasterMonitor.shareInstance().newPateFunc = listview as! LYBlock
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

