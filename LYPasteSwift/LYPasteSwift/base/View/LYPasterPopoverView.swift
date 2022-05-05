//
//  LYPasterPopoverView.swift
//  LYPasteSwift
//
//  Created by user on 2022/5/5.
//

import SwiftUI

struct LYPasterPopoverView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button {
                LYPasterShowManager.instance.showWindow()
                (NSApplication.shared.delegate as? AppDelegate)?.statusBar?.hiddenPopover()
            } label: {
                Text("唤醒")
                .font(.system(size: 15))
                .foregroundColor(.white)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 20)
            .padding(.bottom, 10)
            Divider()
            Button(action: {
                NSApplication.shared.terminate(self)
                (NSApplication.shared.delegate as? AppDelegate)?.statusBar?.hiddenPopover()
            }) {
                Text("关闭")
                .font(.system(size: 15))
                .foregroundColor(.white)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 10)
            .padding(.bottom, 20)
            .padding(.horizontal, 15)
        }
        .padding(0)
    }
}

struct LYPasterPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        LYPasterPopoverView()
    }
}
