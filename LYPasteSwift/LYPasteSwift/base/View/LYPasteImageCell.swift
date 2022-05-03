//
//  LYPasteImageCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteImageCell: LYPasteBaseCell {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    var _imgView: NSImageView?
    var imgView: NSImageView? {
        get{
            if _imgView == nil {
                _imgView = NSImageView.init()
                self.bottomView.addSubview(_imgView!)
                _imgView?.mas_makeConstraints { make in
                    make?.edges.equalTo()(self.bottomView)
                }
            }
            return _imgView
        }
    }
    override func updateUI() -> Void {
        typeLab.stringValue = "图片"
        dateLab.stringValue = model?.date ?? ""
        let path = model?.file_path ?? ""
        do{
            imgView?.image = NSImage.init(contentsOf: URL.init(fileURLWithPath: path))
        } catch let lerror {
            print("str rtf failed: \(lerror)")
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
