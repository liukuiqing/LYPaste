//
//  LYPasteVC.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/15.
//

import Cocoa

class LYPasteVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        var searhF:NSTextField?
        searhF = NSTextField.init(frame: NSRect.init(x: 0, y: 0, width: 20, height: 20))
        searhF?.placeholderString = "ppppp"
//        searhF?.delegate = self
//            searhF?.bezelStyle = .roundedBezel
//            searhF?.wantsLayer = true
//            searhF?.layer?.masksToBounds = true
//            searhF?.layer?.cornerRadius = 10
//            searhF?.layer?.borderColor = CGColor.white
//            searhF?.layer?.borderWidth = 1.0
//            searhF?.userActivity
        searhF?.isSelectable = true
//            searhF?.isEnabled = true
        searhF?.isEditable = true
//            searhF?.isBordered = true
//            searhF?.cell?.usesSingleLineMode = false
//            searhF?.cell?.truncatesLastVisibleLine = false
        self.view.addSubview(searhF!)
        searhF?.mas_makeConstraints({ make in
            make?.right.equalTo()(self.view.mas_right)?.offset()(-20)
            make?.top.equalTo()(self.view.mas_top)?.offset()(15)
            make?.size.mas_equalTo()(CGSize.init(width:100, height:20))
        })
        self.view.window?.fieldEditor(true, for: searhF)
    }
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        return true
    }
    deinit {
        print("deinit")
    }
}
