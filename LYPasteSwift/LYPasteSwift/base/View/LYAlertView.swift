//
//  LYAlertView.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/6/14.
//

import SwiftUI

struct LYAlertView: View {
    @State private var showAlert = false
    var body: some View {
        Button("alert"){}
            .alert(isPresented: $showAlert){
                Alert(title: Text("温馨提示"),
                      message: Text("删除后不可恢复"),
                      dismissButton: .default(Text("ok"))
                )
            }
    }
}

struct LYAlertView_Previews: PreviewProvider {
    static var previews: some View {
        LYAlertView()
    }
}
