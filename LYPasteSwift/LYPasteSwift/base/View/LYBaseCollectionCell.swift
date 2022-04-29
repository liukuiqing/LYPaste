//
//  LYBaseCollectionCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/28.
//

import Cocoa
import SwiftUI

class LYBaseCollectionCell: NSCollectionViewItem {
    @IBOutlet weak var scrollTextView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var textLab: NSTextField!
    
    var model:TestTableModel?{
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.blue.cgColor
//        let tt = NSTextField.init(frame: self.view.bounds)
//        self.view.addSubview(tt)
//        tt.stringValue = "feg;oiufha;ughrfuj"
//        tt.textColor = NSColor.white
//        tt.wantsLayer = true
//
//        self.textView.string  = "dadada"
//        self.scrollTextView.scrollerStyle = .overlay
    }
    
    func updateUI() -> Void {
        switch model?.type {
        case pastTypeRtf:
            setupRtf()
            break
        case pastTypeRtf:
            setupStr()
            break
        default:
            print("unknow type id:\(model?.identifier)")
            textLab.stringValue = model?.type ?? "unknow"
            break
        }
    }
    
    func setupRtf() -> Void {
        let path = model?.file_path ?? ""
        do{
            let dd = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
            if dd != nil {
                textLab.attributedStringValue = NSAttributedString.init(rtf: dd, documentAttributes: nil)!
            }
//            textView.readRTFD(fromFile: path)
        } catch let lerror {
            print("str rtf failed: \(lerror)")
        }
    }
    func setupStr() -> Void {
        textView.string = model?.text ?? ""
    }
}
