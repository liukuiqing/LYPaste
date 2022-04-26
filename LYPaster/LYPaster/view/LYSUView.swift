//
//  LYSUView.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/25.
//

import SwiftUI

struct LYSUView: NSViewRepresentable {
    func makeNSView(context: Context) -> LYWCustomWebview {
//        let v = NSView()
//        let lay = CALayer()
//        v.wantsLayer=true
//        v.layer = lay
//        v.layer?.backgroundColor = Color.purple.cgColor
//        v.needsDisplay = true
//        return v
//       let lab = NSText()
//        lab.backgroundColor = NSColor.clear
//        lab.string = "lab\tt,t\nefsf\nefsf\nefsf"
//        return lab
        let cview = LYWCustomWebview()
        cview.urlStr = "test"
        return cview
        
    }
    
    func updateNSView(_ nsView: LYWCustomWebview, context: Context) {
    }
    
}

struct LYSUView_Previews: PreviewProvider {
    static var previews: some View {
        LYSUView()
    }
}
