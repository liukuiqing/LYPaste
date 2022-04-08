//
//  ContentView.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import SwiftUI

struct ContentView: View {
    let pp = LYPasterMonitor.shareInstance()
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello, world!")
                .padding()
            Button.init("btn") {
//                print(LYPasterMonitor.shareInstance().pasterList())
            }.foregroundColor(Color.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
