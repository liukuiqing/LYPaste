//
//  LYWebview.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/8.
//

import SwiftUI
import WebKit


struct MYWebview: NSViewRepresentable{
    func makeNSView(context: Context) -> WKWebView {
        return self.webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
//        let filePath = NSHomeDirectory().appending("/paster_data/001.rtf")
//        guard filePath != nil else {
//            return
//        }
//        nsView.load(URLRequest(url: URL.init(fileURLWithPath: filePath)))
        let request = URLRequest(url: URL.init(string: "https://blog.csdn.net/qq_36924683/article/details/121198340")!)
        nsView.load(request)
    }
    var _webView:WKWebView?
    
    var webView:WKWebView {
        get{
//            if _webView == nil {
//                _webView = WKWebView()
//            }
            return WKWebView()
        }
    }
//    func makeCoordinator() -> Coordinator {
//
//    }
}

struct LYWebview: View {
    var body: some View{
        MYWebview()
    }
}
struct LYWebview_Previews :PreviewProvider {
    static var previews: some View{
        LYWebview().frame(width: 100, height: 100)
    }
}
