//
//  LYPasteTextCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteTextCell: LYPasteBaseCell {
//    var _strLab: NSTextField?
    lazy var strLab: NSTextField? = {
//        get
//        {
            var _strLab: NSTextField?
            if _strLab == nil {
                _strLab = NSTextField.init()
                self.bottomView.addSubview(_strLab!)
                _strLab?.mas_makeConstraints { make in
                    make?.edges.equalTo()(self.bottomView)
                }
            }
            return _strLab
//        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        strLab?.maximumNumberOfLines = 10
//        strLab?.lineBreakMode = .byTruncatingTail ///和lines一起用会卡死
//        strLab?.isAutomaticTextCompletionEnabled = true
    }
    override func updateUI() -> Void {
        dateLab.stringValue = model?.date ?? ""
        setupStr()
        self.bottomView.layer?.backgroundColor = model?.parseRGBColor().cgColor
        if model != nil {
            if model!.isColorStr == true {
                typeLab.stringValue =  "颜色"
                subTypeLab.stringValue = "text"
            }else{
                typeLab.stringValue =  "文本"
                subTypeLab.stringValue = "text"
            }
        }
    }
    override func setupStr() -> Void {
        let maxCount = 250
        if model?.text.count ?? 0 > maxCount {
            let strIndex = model!.text.index(model!.text.startIndex, offsetBy: maxCount)
            strLab?.stringValue = model!.text.substring(to: strIndex) + "\n……"
        }else{
            strLab?.stringValue = model?.text ?? ""
        }
    }
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        let classStr:String = String("LYPasteBaseCell")
        super.init(nibName: classStr, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
