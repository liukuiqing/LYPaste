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
        LYPasterData.instance.createTable(table: TestTableModel.tabName, of: TestTableModel.self)
        let test = TestTableModel()
        test.description = "老张开车去东北"
        test.identifier = 10086
        LYPasterData.instance.insertToDb(objects: [test], intoTable: TestTableModel.tabName)
        print(";啊;啊;啊;啊;啊;;啊;a")
        let arr = LYPasterData.instance.qureyFromDb(fromTable: TestTableModel.tabName, cls: TestTableModel.self)
        debugPrint("arr ==> \(String(describing: arr?.first?.description))")
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

