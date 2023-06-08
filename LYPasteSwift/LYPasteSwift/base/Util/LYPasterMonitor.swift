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
    weak var newPateFunc: (LYBlock&AnyObject)? //要弱引用
    let paste = NSPasteboard.general
    
    class func shareInstance() -> LYPasterMonitor {
        return _pasterMonitor
    }
    var pasteCount:Int = 0
    var maxDataCount = 200 //最大记录数据量
    
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
    func removeModel(model: TestTableModel){
        originData?.removeAll { $0 == model }
    }
    
    var pTime:Timer?
//    粘贴数据
    var originData:[TestTableModel]?
    var showData:[TestTableModel]?
    var searhKey:String?{
        didSet{
            self.perform(#selector(self.updateShowData), with: nil, afterDelay: 0.3)
        }
    }
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
            var pModel:TestTableModel?
            paste.pasteboardItems?.forEach({ item in
                print("pasteboardItems count:"+"\(item.types.count)")
                let type = item.types.first
                switch type {
                case NSPasteboard.PasteboardType.string:
                    pModel = parseStringPasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.rtf:
                    pModel = parseRTFPasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.png:
                    pModel = parseImagePasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.tiff:
                    pModel = parseTIFFImagePasteItem(item: item, type: type!)
                    break
                case NSPasteboard.PasteboardType.fileURL:
                    pModel = parseFileUrlPasteItem(item: item, type: type!)
                    break
                default :
                    print("un parse :" + "\(type?.rawValue ?? "")")
                }
            })
            print("paste count:\(pasteCount)")
            addNewModel(model: pModel)
            newPateFunc?.voidBlock()
        }
    }
    func parseStringPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> TestTableModel? {
        let tModel = creatModel(withType: pastTypeText)
        tModel.text = item.string(forType: type) ?? ""
        let _ = LYPasterData.instance.insertToDb(objects: [tModel], intoTable: TestTableModel.tabName)
        return tModel
    }
    func parseRTFPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> TestTableModel? {
        let dbModel = creatModel(withType: pastTypeRtf)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).rtf")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            dbModel.text = String.lyRtfData(data) ?? ""
            let _ = LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
            return dbModel
        }else{
            print("rtf failed")
            return nil
        }
    }
    func parseImagePasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> TestTableModel? {
        let dbModel = creatModel(withType: pastTypeImage)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).png")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            let _ = LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
            return dbModel
        }else{
            print("image failed")
            return nil
        }
    }
    func parseTIFFImagePasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> TestTableModel? {
        let dbModel = creatModel(withType: pastTypeImageTIFF)
        let data = item.data(forType: type)!
        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).png")
        if writData(data: data, path: filePath) {
            dbModel.file_path = filePath
            let _ = LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
            return dbModel
        }else{
            print("image tiff failed")
            return nil
        }
    }
    func parseFileUrlPasteItem(item:NSPasteboardItem,type : NSPasteboard.PasteboardType) -> TestTableModel? {
        let dbModel = creatModel(withType: pastTypeFilePath)
        let fileurl = item.string(forType: type)!
//        let filePath = LYPasterMonitor.pasteRootPath().appending("/\(String(describing: dbModel.identifier)).png")
//        if writData(data: data, path: filePath) {
            dbModel.text = fileurl
            let _ = LYPasterData.instance.insertToDb(objects: [dbModel], intoTable: TestTableModel.tabName)
            return dbModel
//        }else{
//            print("image tiff failed")
//            return nil
//        }
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
        }else if model.type == pastTypeFilePath {
            success = paste.setString(model.text, forType: .fileURL)
//            let _ = paste.readFileContentsType(.fileURL, toFile: model.text)
//            success = paste.setString(model.text, forType: .string)
        }
        return success
    }
    
    func creatModel(withType type:String) -> TestTableModel {
        let tModel = TestTableModel.init()
//        tModel.identifier = Int(CACurrentMediaTime())
        tModel.identifier = Int(Date.timeIntervalSinceReferenceDate)
        tModel.date = "\(Date.init())"
        tModel.type = type
        return tModel
    }
    func writData(data:Data?,path filePath:String) -> Bool {
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
extension LYPasterMonitor{
    func getShowData() -> [TestTableModel]? {
        if originData == nil {
            let _ = updateOriginData()
        }
        if showData == nil{
            updateShowData()
        }
        return showData
    }
    @objc func updateShowData() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateShowData), object: nil)
        if originData == nil {
            let _ = updateOriginData()
        }
        if searhKey == nil || searhKey == "" {
            showData = originData
        }else{
            showData = []
            originData?.forEach({ tModel in
                if (tModel.text.range(of: searhKey!) != nil) {
                    showData?.append(tModel)
                }
            })
        }
        newPateFunc?.voidBlock()
    }
    func updateOriginData() -> [TestTableModel] {
        var list = LYPasterData.instance.qureyFromDb(fromTable: TestTableModel.tabName, cls: TestTableModel.self) ?? []
        if list.count>1 {
//            list = list.reversed()
            list = list.sorted(by: { t1, t2 in
                return (t1.identifier ?? 0) > (t2.identifier ?? 0)
            })
        }
        originData = list
        return originData ?? []
    }
    func addNewModel(model:TestTableModel?) {
        if model == nil {
            return
        }
        if originData == nil {
            let _ = updateOriginData()
        }
        originData?.insert(model!, at: 0)
        while (originData?.count ?? 0) > maxDataCount {
            let delModel = originData?.last
            let _ = delModel?.deleteLocalData()
            originData?.removeLast()
        }
        updateShowData()
    }
    
    func delData(modelId:Int){
        if originData != nil {
            for (index,tModel) in originData!.enumerated() {
                if (tModel.identifier == modelId) {
                    let _ = tModel.deleteLocalData()
                    originData?.remove(at: index)
                    break
                }
            }
        }
        if showData != nil {
            for (index,tModel) in showData!.enumerated() {
                if (tModel.identifier == modelId) {
                    showData?.remove(at: index)
                    break
                }
            }
        }
        newPateFunc?.voidBlock()
    }
    func clearData(){
        if originData != nil {
            for (_,tModel) in originData!.enumerated() {
                let _ = tModel.deleteLocalData()
            }
            originData?.removeAll()
        }
        if showData != nil {
            showData?.removeAll()
        }
        newPateFunc?.voidBlock()
    }
}

extension String{
    static func lyRtfData(_ data:Data?) -> String? {
        var restr:String? = ""
        if data == nil {
            return restr
        }
        let  reAtt = NSAttributedString.init(rtf: data!, documentAttributes: nil);
        restr=reAtt?.string
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
