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
//        创建数据文件夹
        let path = LYPasterMonitor.pasteRootPath()
        if FileManager.default.fileExists(atPath: path) == false{
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }catch let lerror {
                print("paste rootpath creat failed: \(lerror)")
            }
        }
    }
    func bind() -> Void {
        self.bindPaste()
    }
    
    func pasterList() -> Array<Any> {
        return ["LYPasterMonitor"]
    }
    var pTime:Timer?
}
//timer
extension LYPasterMonitor{
    
    func bindPaste() -> Void {
        pTime =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkPaste), userInfo: nil, repeats: true)
        RunLoop.main.add(pTime!, forMode: RunLoop.Mode.common)
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
                print("pasteboardItems count:"+"\(item.types.count)")
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
                case NSPasteboard.PasteboardType.tiff:
                    self.parseTIFFImagePasteItem(item: item, type: type!)
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
        let tModel = creatModel(withType: pastTypeText)
        tModel.text = item.string(forType: type) ?? ""
        LYPasterData.instance.insertToDb(objects: [tModel], intoTable: TestTableModel.tabName)
    }
    func parseRTFPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
        let dbModel = creatModel(withType: pastTypeRtf)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).rtf")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            dbModel.text = String.lyRtfData(data) ?? ""
            LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
        }else{
            print("rtf failed")
        }
    }
    func parseImagePasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
        let dbModel = creatModel(withType: pastTypeImage)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).png")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
        }else{
            print("image failed")
        }
    }
    func parseTIFFImagePasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> Void {
        let dbModel = creatModel(withType: pastTypeImageTIFF)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).png")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
        }else{
            print("image tiff failed")
        }
    }
    class func pasteRootPath()->String{
        return NSHomeDirectory().appending("/paster_data")
    }
    func updateToPasteWithModel(_ model:TestTableModel) -> Bool {
        var success = false
        paste.clearContents()
        if model.type == pastTypeText {
            success = paste.setString(model.text, forType: .string)
        }else if model.type == pastTypeRtf{
            do {
                let data = try Data.init(contentsOf: URL.init(fileURLWithPath: model.file_path ?? ""))
                success = paste.setData(data, forType: .rtf)
            } catch let error {
                debugPrint("update paste rtf error \(error.localizedDescription)")
            }
        }else if model.type == pastTypeImage || model.type == pastTypeImageTIFF{
            do {
                let data = try Data.init(contentsOf: URL.init(fileURLWithPath: model.file_path ?? ""))
                success = paste.setData(data, forType: .png)
            } catch let error {
                debugPrint("update paste rtf error \(error.localizedDescription)")
            }
        }
        return success
    }
    
    func creatModel(withType type:String) -> TestTableModel {
        let tModel = TestTableModel.init()
        tModel.identifier = Int(CACurrentMediaTime())
        tModel.date = "\(Date.init())"
        tModel.type = type
        return tModel
        
    }
    func writData(data data:Data?,path filePath:String) -> Bool {
        var success:Bool = false
        if data != nil && filePath.count > 0 {
            do {
                try data!.write(to: NSURL.fileURL(withPath: filePath))
                success = true
            } catch let lerror {
                print("data write failed: \(lerror)")
            }
        }
        return success
    }
}

extension String{
    static func lyRtfData(_ data:Data?) -> String? {
        var restr:String? = ""
        if data == nil {
            return restr
        }
        do {
            let  reAtt = try NSAttributedString.init(rtf: data!, documentAttributes: nil);
            restr=reAtt?.string
        } catch let lerror {
            print("data write failed: \(lerror)")
        }
        return restr
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
