//
//  LYPasterMonitor.swift
//  LYPaste
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import Cocoa
import WCDBSwift

protocol LYBlock {
    func voidBlock() -> Void 
}

var _pasterMonitor:LYPasterMonitor = LYPasterMonitor()
class LYPasterMonitor: NSObject {
    var newPateFunc:LYBlock?
    let paste = NSPasteboard.general
    class func shareInstance() -> LYPasterMonitor {
        return _pasterMonitor
    }
    var pasteCount:Int = 0
    
    override init() {
        NSLog("LYPasterMonitor init")
        super.init()
        self.pasteCount = paste.changeCount
        self.bind()
    }
    func bind() -> Void {
        self.bindPaste()
    }
    
    func pasterList() -> Array<Any> {
        return ["LYPasterMonitor"]
    }
}
//timer
extension LYPasterMonitor{
    
    func bindPaste() -> Void {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkPaste), userInfo: nil, repeats: true)
//        if paste.types?.contains(.string) == false{
//        paste.addTypes([.string,.rtf], owner: self)
//        }
    }
    @objc func checkPaste() -> Void {
        if pasteCount != paste.changeCount {
            pasteCount = paste.changeCount
            //            paste.types?.forEach({ type in
            //                switch type {
            //                case .string :
            //                    let str = paste.string(forType: type)
            //                    print("string:" + (str ?? "nil"))
            //                default :
            //                    print("unknow:" + "\(type) -" + (paste.string(forType: type) ?? "null" ))
            //                }
            //            })
            paste.pasteboardItems?.forEach({ item in
                print(item.types.count)
                let type = item.types.first
                switch type {
                case NSPasteboard.PasteboardType.string:
                    self.parseStringPasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.rtf:
                    self.parseRTFPasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.png:
                    self.parseImagePasteItem(item: item, type: type!)
                    break
                default :
                    print("un parse :" + "\(type?.rawValue)")
                }
            })
            print(pasteCount)
            newPateFunc?.voidBlock()
        }
    }
    func parseStringPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
//        print("\(item.string(forType: type) ?? "none")")
        let tModel = TestTableModel()
//        test.description = "老张开车去东北"
        tModel.identifier = Int(CACurrentMediaTime())
        tModel.text = item.string(forType: type) ?? ""
        tModel.type = pastTypeText
        tModel.date = "\(Date.init())"
        LYPasterData.instance.insertToDb(objects: [tModel], intoTable: TestTableModel.tabName)
    }
    func parseRTFPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
        do {
            let dbModel = TestTableModel()
            dbModel.identifier = Int(CACurrentMediaTime())
            let data = item.data(forType: type)!
            let path = NSHomeDirectory().appending("/paster_data")
            let filePath = path.appending("/\(String(describing: dbModel.identifier)).rtf")
            if FileManager.default.fileExists(atPath: path) == false{
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            try data.write(to: NSURL.fileURL(withPath: filePath))
            dbModel.type = pastTypeRtf
            dbModel.text = item.string(forType: type) ?? ""
            dbModel.date = "\(Date.init())"
            dbModel.file_path = filePath
            LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
        } catch let lerror {
            print("rtf failed: \(lerror)")
        }
    }
    func parseImagePasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
        do {
            let dbModel = TestTableModel()
            dbModel.identifier = Int(CACurrentMediaTime())
            let data = item.data(forType: type)!
            let path = NSHomeDirectory().appending("/paster_data")
            let filePath = path.appending("/\(String(describing: dbModel.identifier)).png")
            if FileManager.default.fileExists(atPath: path) == false{
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            try data.write(to: NSURL.fileURL(withPath: filePath))
            dbModel.type = pastTypeImage
            dbModel.text = item.string(forType: type) ?? ""
            dbModel.date = "\(Date.init())"
            dbModel.file_path = filePath
            LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
        }catch let lerror {
            print("image failed: \(lerror)")
        }
    }
    class func pasteRootPath()->String{
        return NSHomeDirectory().appending("/paster_data")
    }
}
//extension LYPasterMonitor:NSPasteboardTypeOwner{
//    func pasteboard(_ sender: NSPasteboard, provideDataForType type: NSPasteboard.PasteboardType) {
//        print("\(type.rawValue)")
//    }
//
//    func pasteboardChangedOwner(_ sender: NSPasteboard) {
//        print("\(sender)")
//    }
//}
