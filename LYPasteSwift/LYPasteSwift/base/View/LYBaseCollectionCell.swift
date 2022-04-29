//
//  LYBaseCollectionCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/28.
//

import Cocoa

class LYBaseCollectionCell: NSCollectionViewItem {
    @IBOutlet weak var scrollTextView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.blue.cgColor
//        let tt = NSTextField.init(frame: self.view.bounds)
//        self.view.addSubview(tt)
//        tt.stringValue = "feg;oiufha;ughrfuj"
//        tt.textColor = NSColor.white
//        tt.wantsLayer = true
//
//        self.textView.string  = "dadada"
        let path = LYPasterMonitor.pasteRootPath().appending("/001.rtf")
        do{
//            let text = try String.init(contentsOfFile: path, encoding: .utf8)
//            textView.string = text
//            let dd = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
//            textView.attributedString = NSAttributedString.init(rtf: dd, documentAttributes: nil)
            textView.readRTFD(fromFile: path)
        } catch let lerror {
            print("str rtf failed: \(lerror)")
        }
        
    }
    
}
