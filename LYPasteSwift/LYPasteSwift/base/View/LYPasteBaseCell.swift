//
//  LYPasteBaseCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/3.
//

import Cocoa

class LYPasteBaseCell: NSCollectionViewItem {
    @IBOutlet weak var typeLab: NSTextField!
    @IBOutlet weak var dateLab: NSTextField!
    @IBOutlet weak var bottomView: NSView!
    @IBOutlet weak var unknowLab: NSTextField!
    @IBOutlet weak var rightIconView: NSImageView!
    
    var model:TestTableModel?{
        didSet{
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
