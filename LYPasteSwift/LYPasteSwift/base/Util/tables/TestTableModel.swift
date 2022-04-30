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
}
