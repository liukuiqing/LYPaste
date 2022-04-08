//
//  TestTableModel.swift
//  LYPaster
//
//  Created by user on 2022/4/8.
//

import Cocoa
import WCDBSwift
class TestTableModel: TableCodable {
    
    static let tabName = "test_table"
    
    var identifier: Int? = nil
    var description: String? = nil
    var test: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TestTableModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case description
        case test
        
        static var columnConstraintBindings: [TestTableModel.CodingKeys : ColumnConstraintBinding]?{
            return [
                identifier : ColumnConstraintBinding(isPrimary: true),
                description: ColumnConstraintBinding(isNotNull: true, defaultTo: "啦啦啦啦啦"),
                test: ColumnConstraintBinding(isNotNull: false, defaultTo: "tttttt")
            ]
        }
        static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
            return [
                "_index": IndexBinding(indexesBy: test)
            ]
        }
    }
}
