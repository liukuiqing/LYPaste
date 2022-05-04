//
//  LYColor.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/5/4.
//

import Cocoa

//class LYColor: NSObject {
//
//}
extension NSColor{
    class func hex(hexRgba:Int32) -> NSColor {
        let r = (hexRgba>>16)&0xff
        let g = (hexRgba>>8)&0xff
        let b = hexRgba&0xff
        return NSColor.init(red: Double(r)/255.0, green: Double(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}
