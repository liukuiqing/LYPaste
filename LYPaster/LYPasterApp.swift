//
//  LYPasterApp.swift
//  LYPaster
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("log-didFinishLaunching")
    }
}

@main
struct LYPasterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

