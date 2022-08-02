//
//  LYPasteRTFCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteRTFCell: LYPasteTextCell {
//    var _strLab: NSTextField?
//    var strLab: NSTextField? {
//        get{
//            if _strLab == nil {
//                _strLab = NSTextField.init()
//                self.bottomView.addSubview(_strLab!)
//                _strLab?.mas_makeConstraints { make in
//                    make?.edges.equalTo()(self.bottomView)
//                }
//            }
//            return _strLab
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        strLab?.maximumNumberOfLines = 10
    }
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        let classStr:String = String("LYPasteBaseCell")
        super.init(nibName: classStr, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateUI() {
        dateLab.stringValue = model?.date ?? ""
        setupRtf()
        self.bottomView.layer?.backgroundColor = model?.parseRGBColor().cgColor
        if model != nil {
            if model!.isColorStr == true {
                typeLab.stringValue =  "颜色"
                subTypeLab.stringValue = "rtf"
            }else{
                typeLab.stringValue =  "文本"
                subTypeLab.stringValue = "rtf"
            }
        }
    }
    override func setupRtf() -> Void {
        let path = model?.file_path ?? ""
        strLab?.stringValue = "加载中……"
        DispatchQueue.global().async {
            do{
                let dd:Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
                if dd != nil {
                    DispatchQueue.main.async {
                        self.strLab?.attributedStringValue = NSAttributedString.init(rtf: dd!, documentAttributes: nil)!
                    }
                }
                //            textView.readRTFD(fromFile: path)
            } catch let lerror {
                print("rtf failed: \(lerror)")
            }
        }
    }
    
}
