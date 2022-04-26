//
//  ContentView.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import SwiftUI

struct ContentView: View {
//    let pp = LYPasterMonitor.shareInstance()
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello, world!")
                .padding()
            Button.init("btn") {
//                print(LYPasterMonitor.shareInstance().pasterList())
            }.foregroundColor(Color.red)
            LYWebview().background(Color.yellow).frame(width: 100, height: 100)
            LYSUView().frame(width: 800, height: 100).background(Color.green)
//            LYWCustomWebview().frame(width: 100, height: 100).background(Color.yellow)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
