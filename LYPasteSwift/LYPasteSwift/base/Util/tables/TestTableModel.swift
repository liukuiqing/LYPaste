//
//  TestTableModel.swift
//  LYPaster
//
//  Created by user on 2022/4/8.
//

import Cocoa
import WCDBSwift

let pastTypeText        = "pastText"
let pastTypeRtf         = "pastTextRtf"
let pastTypeImage       = "pastTextImage"
let pastTypeImageTIFF   = "pastTextImageTiff" ///标签图像文件格式
let pastTypeFilePath    = "pastFilePath"

class TestTableModel: TableCodable  {
    
    static let tabName = "test_table"
    
    var identifier: Int? = nil
    var description: String? = ""
    var test: String? = ""
    
    var file_path:String? = ""
    var type:String = ""
    var text:String = ""
    var date:String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TestTableModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
        case test
        case text
        case file_path
        case type
        case date
        
        static var columnConstraintBindings: [TestTableModel.CodingKeys : ColumnConstraintBinding]?{
            return [
                identifier : ColumnConstraintBinding(isPrimary: true),
                description: ColumnConstraintBinding(isNotNull: true, defaultTo: "啦啦啦啦啦"),
                test: ColumnConstraintBinding(isNotNull: false, defaultTo: "tttttt"),
                file_path: ColumnConstraintBinding(isNotNull: false, defaultTo: "")
                ,
                type: ColumnConstraintBinding(isNotNull: false, defaultTo: ""),
                text: ColumnConstraintBinding(isNotNull: false, defaultTo: ""),
                date: ColumnConstraintBinding(isNotNull: false, defaultTo: "")
            ]
        }
        static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
            return [
                "_index": IndexBinding(indexesBy: identifier)
            ]
        }
    }
    func cellId() -> String {
        switch type{
        case pastTypeText:
            return "textcell"
        case pastTypeRtf:
            return "rtfcell"
        case pastTypeImage:
            return "imagecell"
        case pastTypeImageTIFF:
            return "tiffcell"
        case pastTypeFilePath:
            return "filepathcell"
        default:
            return "basecell"
        }
    }
    func deleteLocalData()->Bool {
        LYPasterData.instance.deleteFromDb(fromTable: TestTableModel.tabName, where: TestTableModel.Properties.identifier == identifier ?? 0)
        switch type{
        case pastTypeText:
            return true
        case pastTypeFilePath:
            return true
//            break
        case pastTypeRtf:
            return deletefile(localPath: file_path)
//            break
        case pastTypeImage:
            return deletefile(localPath: file_path)
//            break
        case pastTypeImageTIFF:
            return deletefile(localPath: file_path)
//            break
        default:
            break
        }
        return false
    }
    var isColorStr = false
    
    func parseRGBColor()->NSColor {
        if type == pastTypeText || type == pastTypeRtf {
            if NSColor.isValidhexStr(hexRgbStr: self.text) {
                isColorStr = true
                return NSColor.hexStr(hexRgbStr: self.text)
            }
        }
        isColorStr = false
        return NSColor.clear
    }
}

func deletefile(localPath:String?) -> Bool {
    if localPath != nil && FileManager.default.fileExists(atPath: localPath!) {
        do {
            try FileManager.default.removeItem(at: URL.init(fileURLWithPath: localPath!))
            return true
        } catch let error {
            print("deletefile:failed:\(localPath ?? "") - \(error)")
        }
    }
    return false
}
