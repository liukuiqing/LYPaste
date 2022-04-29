//
//  LYWCustomWebview.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/25.
//

import Cocoa
import WebKit

@available(macOS 10.10, *)
class LYWCustomWebview: NSView {
    var webview:WKWebView?
    var urlStr:String? {
//        get{
//            return webview.url?.absoluteString
//        }
        didSet{
            url = URL.init(string: urlStr ?? "")!
        }
    }
    var url:URL?{
        didSet{
            if webview == nil{
                let config = WKWebViewConfiguration()
                //            config.select
                
                let preferences = WKPreferences()
                //是否支持JavaScript
                preferences.javaScriptEnabled = true;
                //不通过用户交互，是否可以打开窗口
                preferences.javaScriptCanOpenWindowsAutomatically = true;
                config.preferences = preferences;
                
//                webview = WKWebView.init(frame: NSRect.init(x: 0, y: 0, width: 900, height: 500), configuration: config)
                webview = WKWebView.init(frame: self.bounds, configuration: config)
                webview?.uiDelegate = self
                webview?.navigationDelegate = self
                self.addSubview(webview!)
            }
            webview?.load(URLRequest.init(url: url ?? URL(fileURLWithPath: "")))
        }
    }
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        webview?.frame = NSRect.init(origin: CGPoint.zero, size: self.frame.size)
    }
    
}
extension LYWCustomWebview :WKUIDelegate{
    
}

extension LYWCustomWebview :WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webview start")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webview finish")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webview didFail")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        print("webview Action Allow")
        return WKNavigationActionPolicy.allow
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("webview Response Allow")
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
}
