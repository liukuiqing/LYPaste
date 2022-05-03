//
//  LYPasteListView.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/27.
//

import Cocoa
import WCDBSwift

class LYPasteListView: NSView,LYBlock {
    func voidBlock() {
        var list = LYPasterData.instance.qureyFromDb(fromTable: TestTableModel.tabName, cls: TestTableModel.self) ?? []
        if list.count>1 {
            list = list.reversed()
        }
        _dataList = list
        self.listView.reloadData()
    }
    var _dataList:[TestTableModel]?
    var dataList:[TestTableModel]{
        get{
            if _dataList == nil {
                var list = LYPasterData.instance.qureyFromDb(fromTable: TestTableModel.tabName, cls: TestTableModel.self) ?? []
                if list.count>1 {
                    list = list.reversed()
                }
                _dataList = list
            }
            return _dataList!
        }
    }
    var listView:NSCollectionView {
        get{
            let flowlayout = NSCollectionViewFlowLayout.init()
            flowlayout.scrollDirection = .horizontal
            
            let collectionView = NSCollectionView.init(frame: self.bounds)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout  = flowlayout
            collectionView.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "cell"))
            collectionView.register(LYPasteBaseCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "basecell"))
            collectionView.register(LYPasteRTFCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "rtfcell"))
            collectionView.register(LYPasteTextCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "textcell"))
            collectionView.register(LYPasteImageCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "imagecell"))
            collectionView.register(LYPasteImageCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "tiffcell"))
            self.scrollView.documentView = collectionView
            collectionView.wantsLayer = true
            collectionView.layer?.backgroundColor = NSColor.gray.cgColor
            return collectionView
        }
    }
    var scrollView:NSScrollView{
        get{
            let sview = NSScrollView.init(frame: self.bounds)
            sview.hasHorizontalScroller = false
            self.addSubview(sview)
            sview.mas_makeConstraints { make in
                make?.edges.equalTo()(self)
            }
            return sview
        }
    }
    
    func clickCell(_ model:TestTableModel) -> Void {
        LYPasterData.instance.deleteFromDb(fromTable: TestTableModel.tabName, where: TestTableModel.Properties.identifier == model.identifier ?? 0)
//        model.identifier = Int(CACurrentMediaTime())
//        model.date = "\(Date.init())"
//        LYPasterData.instance.insertToDb(objects: [model], intoTable: TestTableModel.tabName)
        LYPasterMonitor.shareInstance().updateToPasteWithModel(model)
//        voidBlock()
    }
}
extension LYPasteListView:NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize.init(width: 270, height: 290)
    }
}
extension LYPasteListView:NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let model = dataList[indexPath.item]
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: model.cellId()), for: indexPath) as! LYPasteBaseCell
        cell.model = model
        weak var weak_self = self
        cell.modelBlock = { smodel in
            weak_self?.clickCell(smodel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        for indexp in indexPaths {
            print("\(indexp.item)")
        }
    }
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexPaths: Set<IndexPath>, with event: NSEvent) -> Bool {
        return true
    }
}
