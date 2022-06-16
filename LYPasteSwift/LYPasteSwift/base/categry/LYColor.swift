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
    class func hexStr(hexRgbStr:String) -> NSColor {
//        if hexRgbStr.count == 7 && hexRgbStr.hasPrefix("#") {
//            return hex(hexRgba: Int32(hexRgbStr.replacingOccurrences(of: "#", with: ""))!)
//        }
//        return hex(hexRgba: Int32(hexRgbStr) ?? 0x0)
        let newHex = hexRgbStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner.init(string: newHex)
        if newHex.hasPrefix("#"){
            scanner.scanLocation = 1
        }else if newHex.hasPrefix("0x"){
            scanner.scanLocation = 2
        }
        var hexInt:UInt32 = 0
        scanner.scanHexInt32(&hexInt)
        return hex(hexRgba:Int32(hexInt))
    }
    class func isValidhexStr(hexRgbStr:String) -> Bool {
        if hexRgbStr.count == 7 && hexRgbStr.hasPrefix("#") {
            return true
        }else if hexRgbStr.count == 8 && hexRgbStr.hasPrefix("0x"){
            return true
        }
        return false
    }
}
