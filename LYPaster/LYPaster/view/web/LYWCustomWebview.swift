//
//  LYWCustomWebview.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/25.
//

import Cocoa
import WebKit

class LYWCustomWebview: NSView {
    var webview = WKWebView.init(frame: NSRect.init(x: 0, y: 0, width: 600, height: 900))
    var urlStr:String? {
//        get{
//            return webview.url?.absoluteString
//        }
        didSet{
//            print(urlStr);
//            webview.configuration
//            let config = WKWebViewConfiguration()
//            config.select
//            webview.uiDelegate = self;
//            webview.navigationDelegate = self;
            let url = URL.init(string: urlStr ?? "")!
            webview.load(URLRequest.init(url: url))
            webview.frame = NSRect.init(x: 0, y: 0, width: 600, height: 90)
            self.addSubview(webview)
        }
    }
    
    
}
