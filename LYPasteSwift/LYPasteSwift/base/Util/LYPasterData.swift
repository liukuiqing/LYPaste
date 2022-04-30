//
//  LYPasteData.swift
//  LYPaste
//
//  Created by dy_liukuiqing on 2022/4/7.
//

import Cocoa
import WCDBSwift

struct LYPasterDataBasePath {
    static let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true).last! + "/LYDB/LYDB.db"
}

class LYPasterData: NSObject {
    static let instance = LYPasterData()
    var dataBase: Database?

    private override init() {
        super.init()
        dataBase = createDB()
    }
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    
    private func createDB() -> Database {
        debugPrint(LYPasterDataBasePath.dbPath)
        return Database(withPath: LYPasterDataBasePath.dbPath)
    }
}

extension LYPasterData{
    
    ///创建表
    func createTable<T: TableDecodable>(table: String, of ttype:T.Type) -> Void {
        do {
            try dataBase?.create(table: table, of:ttype)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    ///插入
    func insertToDb<T: TableEncodable>(objects: [T] ,intoTable table: String) -> Bool {
        var success = false
        do {
            success = ((try dataBase?.insert(objects: objects, intoTable: table)) != nil)
            if !success {
//                dataBase?.update(table: table, on: <#T##[PropertyConvertible]#>, with: <#T##[ColumnEncodable]#>)
                print("inser DB error 可能有新字段！！！");
            }
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
            success = false
        }
        return success
    }
    
    ///修改
    func updateToDb<T: TableEncodable>(table: String, on propertys:[PropertyConvertible],with object:T,where condition: Condition? = nil) -> Void{
        do {
            try dataBase?.update(table: table, on: propertys, with: object,where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }
    
    ///删除
    func deleteFromDb(fromTable: String, where condition: Condition? = nil) -> Void {
        do {
//            try dataBase?.delete(fromTable: fromTable, where:condition)
            try dataBase?.delete(fromTable: fromTable, where:TestTableModel.Properties.text == "22")
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    
    ///查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    ///删除数据表
    func dropTable(table: String) -> Void {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    
    /// 删除所有与该数据库相关的文件
    func removeDbFile() -> Void {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
    }
}
