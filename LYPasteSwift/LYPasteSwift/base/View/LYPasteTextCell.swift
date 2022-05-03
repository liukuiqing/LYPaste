//
//  LYPasteTextCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteTextCell: LYPasteBaseCell {
    var _strLab: NSTextField?
    var strLab: NSTextField? {
        get{
            if _strLab == nil {
                _strLab = NSTextField.init()
                self.bottomView.addSubview(_strLab!)
                _strLab?.mas_makeConstraints { make in
                    make?.edges.equalTo()(self.bottomView)
                }
            }
            return _strLab
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    override func updateUI() -> Void {
        typeLab.stringValue = "文本"
        dateLab.stringValue = model?.date ?? ""
        setupStr()
    }
    override func setupStr() -> Void {
        strLab?.stringValue = model?.text ?? ""
    }
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        let classStr:String = String("LYPasteBaseCell")
        super.init(nibName: classStr, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
