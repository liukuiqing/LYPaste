//
//  LYPasteListView.swift
//  LYPasteSwift
//
//  Created by dy_liukuiqing on 2022/4/27.
//

import Cocoa

class LYPasteListView: NSView {
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
        return 4
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init(rawValue: "basecell"), for: indexPath)
        cell.textField?.stringValue = "\(indexPath)"
        return cell
    }
    
    
}
