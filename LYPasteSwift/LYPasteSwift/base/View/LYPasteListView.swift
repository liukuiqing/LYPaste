//
//  LYPasteListView.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/27.
//

import Cocoa

class LYPasteListView: NSView {
    var dataList:[TestTableModel]{
        get{
            return  LYPasterData.instance.qureyFromDb(fromTable: TestTableModel.tabName, cls: TestTableModel.self) ?? []
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
            self.scrollView.documentView = collectionView
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
        let cell:LYBaseCollectionCell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "basecell"), for: indexPath) as! LYBaseCollectionCell
        cell.model = dataList[indexPath.item]
        return cell
    }
    
    
}
