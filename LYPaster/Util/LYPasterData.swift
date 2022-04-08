//
//  LYPasteData.swift
//  LYPaste
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import Cocoa
//import WCDB

class LYPasterData: NSObject {
    static let instance = LYPasterData()
    
    private override init() {}
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
}
