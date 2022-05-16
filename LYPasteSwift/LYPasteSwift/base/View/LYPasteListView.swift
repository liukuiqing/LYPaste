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
        updateUI()
    }
    func updateUI() {
        _dataList = LYPasterMonitor.shareInstance().getShowData()
        self.listView.reloadData()
        noDataLab.isHidden = (_dataList?.count ?? 0) > 0
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
    var _listView:NSCollectionView?
    var listView:NSCollectionView {
        get{
            if _listView==nil {
                
                let flowlayout = NSCollectionViewFlowLayout.init()
                flowlayout.scrollDirection = .horizontal
                flowlayout.minimumLineSpacing = 20
                flowlayout.minimumInteritemSpacing = 0
                flowlayout.sectionInset = NSEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
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
                _listView = collectionView
                self.scrollView.documentView = collectionView
                collectionView.wantsLayer = true
                collectionView.layer?.backgroundColor = NSColor.gray.cgColor
                self.setupUI()
            }
            return _listView!
        }
    }
    var _scrollView:NSScrollView?
    var scrollView:NSScrollView{
        get{
            if _scrollView == nil {
                _scrollView = NSScrollView.init(frame: self.bounds)
                _scrollView?.hasHorizontalScroller = false
                self.addSubview(_scrollView!)
                _scrollView!.mas_makeConstraints { make in
                    make?.top.offset()(40)
                    make?.left.equalTo()(self)
                    make?.bottom.equalTo()(self)
                    make?.right.equalTo()(self)
                }
            }
            return _scrollView!
        }
    }
    var _noDataLab:NSTextField?
    var noDataLab:NSTextField{
        get{
            if _noDataLab == nil {
                _noDataLab = NSTextField.init(frame: self.bounds)
                self.addSubview(_noDataLab!)
                _noDataLab?.stringValue = "没有数据"
                _noDataLab?.textColor = NSColor.white
                _noDataLab?.backgroundColor = NSColor.clear
                _noDataLab?.font = NSFont.boldSystemFont(ofSize: 20)
                _noDataLab?.isBordered = false
                _noDataLab?.isEditable = false
                _noDataLab?.alignment = .center
                _noDataLab?.mas_makeConstraints({ make in
                    make?.centerX.equalTo()(self)
                    make?.centerY.offset()(30)
                    make?.height.mas_equalTo()(30)
                    make?.width.mas_equalTo()(200)
                })
            }
            return _noDataLab!
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
    var searhF:NSSearchField?
    func setupUI() {
        if searhF == nil {
            searhF = NSSearchField.init(frame: NSRect.init(x: 0, y: 0, width: 20, height: 20))
            searhF?.placeholderString = "输入搜索关键字"
            searhF?.delegate = self
//            searhF?.bezelStyle = .roundedBezel
//            searhF?.wantsLayer = true
//            searhF?.layer?.masksToBounds = true
//            searhF?.layer?.cornerRadius = 10
//            searhF?.layer?.borderColor = CGColor.white
//            searhF?.layer?.borderWidth = 1.0
//            searhF?.userActivity
            searhF?.isSelectable = true
//            searhF?.isEnabled = true
            searhF?.isEditable = true
//            searhF?.isBordered = true
//            searhF?.cell?.usesSingleLineMode = false
//            searhF?.cell?.truncatesLastVisibleLine = false
            self.addSubview(searhF!)
            searhF?.mas_makeConstraints({ make in
                make?.right.equalTo()(self.mas_right)?.offset()(-20)
                make?.top.equalTo()(self.mas_top)?.offset()(15)
                make?.size.mas_equalTo()(CGSize.init(width:100, height:20))
            })
        }
    }
    deinit {
        print("listview deinit")
        LYPasterMonitor.shareInstance().searhKey = nil
    }
}
extension LYPasteListView:NSSearchFieldDelegate{
    
//}
//extension LYPasteListView:NSTextFieldDelegate {
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        return true
    }
    func textField(_ textField: NSTextField, textView: NSTextView, shouldSelectCandidateAt index: Int) -> Bool {
        return true
    }
    func controlTextDidChange(_ obj: Notification) {
        print("\(searhF?.stringValue)")
        LYPasterMonitor.shareInstance().searhKey = searhF?.stringValue
    }
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        return true
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
