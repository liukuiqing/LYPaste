//
//  LYImageCollectionCell.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/29.
//

import Cocoa

class LYImageCollectionCell: NSCollectionViewItem {
    @IBOutlet weak var imgView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    var model:TestTableModel?{
        didSet{
            updateUI()
        }
    }
    func updateUI() -> Void {
            let path = model?.file_path ?? ""
            do{
                imgView.image = NSImage.init(contentsOf: URL.init(fileURLWithPath: path))
            } catch let lerror {
                print("str rtf failed: \(lerror)")
            }
    }
    
}
