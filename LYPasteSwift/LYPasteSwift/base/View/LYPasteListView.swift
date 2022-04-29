//
//  LYPasteListView.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/27.
//

import Cocoa

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
            collectionView.register(LYBaseCollectionCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "basecell"))
            collectionView.register(LYImageCollectionCell.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "imagecell"))
            self.scrollView.documentView = collectionView
            collectionView.wantsLayer = true
            collectionView.layer?.backgroundColor = NSColor.gray.cgColor
            return collectionView
        }
    }
    var scrollView:NSScrollView{
        get{
            let sview = NSScrollView.init(frame: self.bounds)
            self.addSubview(sview)
            sview.mas_makeConstraints { make in
                make?.edges.equalTo()(self)
            }
            return sview
        }
    }
}
extension LYPasteListView:NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize.init(width: 150, height: 250)
    }
}
extension LYPasteListView:NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell : NSCollectionViewItem
        let model = dataList[indexPath.item]
        if model.type == pastTypeImage{
           let imageCell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "imagecell"), for: indexPath) as! LYImageCollectionCell
            imageCell.model = model
            cell = imageCell
        }else{
           let baseCell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "basecell"), for: indexPath) as! LYBaseCollectionCell
            baseCell.model = model
            cell = baseCell
        }
        return cell
    }
    
    
}
