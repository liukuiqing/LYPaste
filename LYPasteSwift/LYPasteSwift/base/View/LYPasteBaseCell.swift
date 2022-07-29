//
//  LYPasteBaseCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteBaseCell: NSCollectionViewItem {
    @IBOutlet weak var bgView: NSView!
    @IBOutlet weak var topView: NSView!
    @IBOutlet weak var typeLab: NSTextField!
    @IBOutlet weak var dateLab: NSTextField!
    @IBOutlet weak var bottomView: NSView!
    @IBOutlet weak var unknowLab: NSTextField!
    @IBOutlet weak var rightIconView: NSImageView!
    @IBOutlet weak var subTypeLab: NSTextField!
    
    var model:TestTableModel?{
        didSet{
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.wantsLayer = true
        self.bgView.layer?.masksToBounds = true
        self.bgView.layer?.cornerRadius = 8
//        41 42 47 0x292a2f
        self.bgView.layer?.backgroundColor = NSColor.hex(hexRgba: 0x292a2f).cgColor

        self.topView.wantsLayer = true
        self.topView.layer?.backgroundColor = NSColor.hex(hexRgba: 0x00b9ff).cgColor
        
        self.bottomView.wantsLayer = true
        
        self.subTypeLab.stringValue = ""
        self.subTypeLab.wantsLayer = true

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
            print("unknow type id:\(String(describing: model?.identifier))")
            unknowLab.stringValue = model?.type ?? "unknow"
            unknowLab.isHidden = false
            break
        }
    }
    
    func setupRtf() -> Void {

    }
    func setupStr() -> Void {
        
    }
    @IBAction func clickCell(_ sender: NSButton) {
        if modelBlock != nil{
            modelBlock?(model!)
        }
    }
    var modelBlock:((_ model:TestTableModel)->Void)?
}
