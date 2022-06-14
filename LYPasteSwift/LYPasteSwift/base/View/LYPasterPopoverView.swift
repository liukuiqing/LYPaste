//
//  LYPasterPopoverView.swift
//  LYPasteSwift
//
//  Created by user on 2022/5/5.
//

import SwiftUI

struct LYPasterPopoverView: View {
    @State private var showAlert = false
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
//            Button {
//                LYPasterShowManager.instance.showWindow()
//                (NSApplication.shared.delegate as? AppDelegate)?.statusBar?.hiddenPopover()
//            } label: {
//                Text("唤醒")
//                .font(.system(size: 15))
//                .foregroundColor(.white)
//            }
//            .buttonStyle(BorderlessButtonStyle())
//            .padding(.top, 20)
//            .padding(.bottom, 10)
            Text("Command+Shift+v")
                .font(.system(size: 10))
                .frame(height: 40, alignment: .center)
                .foregroundColor(.white)
            Divider()
            btn(title: "清除记录") {
                    (NSApplication.shared.delegate as? AppDelegate)?.statusBar?.hiddenPopover()
                    clecarAction()
                self.showAlert = true
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("温馨提示"),
                      message: Text("删除后不可恢复!"),
                      primaryButton: Alert.Button.default(Text("删除"),action: {
                    LYPasterMonitor.shareInstance().clearData()
                }),
                      secondaryButton: .cancel(Text("取消")))
            }
            Divider()
            btn(title: "退出") {
                NSApplication.shared.terminate(self)
                (NSApplication.shared.delegate as? AppDelegate)?.statusBar?.hiddenPopover()
            }
        }
        .padding(0)
    }
    func clecarAction() {

    }
}
extension LYPasterPopoverView{
    func btn(title:String,action: @escaping () -> Void)->some View{
        return Button(action: action) {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(.top, 10)
        .padding(.bottom, 10)
        .padding(.horizontal, 15)
    }
}

struct LYPasterPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        LYPasterPopoverView()
    }
}
