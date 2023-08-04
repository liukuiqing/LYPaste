//
//  LYPastePublicHtmlCell.swift
//  LYPasteSwift
//
//  Created by liukuiqing on 2023/8/4.
//

import Cocoa

class LYPastePublicHtmlCell: LYPasteRTFCell {
    override func setupRtf() -> Void {
        let path = model?.file_path ?? ""
        strLab?.stringValue = "加载中……"
        DispatchQueue.global().async {
            do{
                let dd:Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
                if dd != nil {
                    DispatchQueue.main.async {
                        self.strLab?.attributedStringValue = NSAttributedString.init(html: dd!, documentAttributes: nil) ?? NSAttributedString.init()
                    }
                }
            } catch let lerror {
                print("rtf failed: \(lerror)")
            }
        }
    }
    
}
