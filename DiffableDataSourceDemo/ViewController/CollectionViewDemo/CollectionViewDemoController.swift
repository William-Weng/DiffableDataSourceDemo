//
//  CollectionViewDemoController.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit
import WWPrint

final class CollectionViewDemoController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    private lazy var dataSource = dataSourceMaker()
    private lazy var hirerachicalInformations = hirerachicalInformationsMaker(count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
        myCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewDemoController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeItem(indexPath: indexPath)
    }
}

// MARK: - 小工具
private extension CollectionViewDemoController {
        
    /// [初始化設定](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-diffable-data-source-顯示表格內容-4e4aa0294bf6)
    func initSetting() {
        inisSetting(appearance: .insetGrouped)
        initSnapshotSetting(sectionSnapshotMaker())
        dataSourceReorderingHandlers()
    }
    
    /// [初始化Layout設定](https://www.appcoda.com.tw/ios-14-diffable-data-source/)
    /// - Parameter layout: [UICollectionLayoutListConfiguration.Appearance](https://useyourloaf.com/blog/button-configuration-in-ios-15/)
    func inisSetting(appearance: UICollectionLayoutListConfiguration.Appearance) {
        
        let config = UICollectionLayoutListConfiguration._build(appearance: appearance, backgroundColor: .clear)
        
        myCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        myCollectionView.dataSource = dataSource
    }
    
    /// [初始化dataSource的對照組](https://www.gushiciku.cn/pl/pXoE/zh-hk)
    /// - Parameter snapshot: [NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>](https://medium.com/jeremy-xue-s-blog/swift-轉移到-combine-9b9cc91a0748)
    func initSnapshotSetting(_ snapshot: NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>) {
        dataSource.apply(snapshot, to: "Root", animatingDifferences: true, completion: nil)
    }
    
    /// [設定Header + Cells間的關係 / 用Identify來當reloadData的Key比對之用](https://juejin.cn/post/6908885450744823821)
    /// => reloadData() / reloadSection()
    /// - Returns: NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>
    func sectionSnapshotMaker() -> NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem> {
        
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>()
        
        for data in hirerachicalInformations {
            
            let header = Constant.OutlineItem.parent(data)
            let cells = data.childItems.map { Constant.OutlineItem.child($0) }
            
            sectionSnapshot.append([header])
            sectionSnapshot.append(cells, to: header)
            sectionSnapshot.expand([header])
        }
        
        return sectionSnapshot
    }
    
    /// [當Item在移動時的處理](https://medium.com/@le821227/diffable-datasource-for-uitableview-uicollectionview-6c4436362ae6)
    func dataSourceReorderingHandlers() {
        
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = { transaction in
            wwPrint(transaction.difference)
        }
    }
    
    /// [階層式資料 -> 折疊 (測試資料)](https://www.jianshu.com/p/35fdf7899128)
    /// => [Parent + [Child, Child, Child, Child, Child]]
    /// - Returns: [Parent]
    func hirerachicalInformationsMaker(count: Int) -> [Model.Parent] {
        
        let data = [
            Model.Parent(item: "A開頭的", childItems: Array(1...count).map { Model.Child(item: "A-\($0)") }),
            Model.Parent(item: "あ開頭的", childItems: Array(1...count).map { Model.Child(item: "あ-\($0)") }),
            Model.Parent(item: "ㅏ開頭的", childItems: Array(1...count).map { Model.Child(item: "ㅏ-\($0)") }),
        ]
        
        return data
    }
    
    /// [產生資料源 = Cell長相 + 項目資料 (dequeueConfiguredReusableCell)](https://juejin.cn/post/6850418106381434894)
    /// => collectionView(_:numberOfItemsInSection:) + collectionView(_:cellForItemAt:)
    /// - Returns: UICollectionViewDiffableDataSource<String, OutlineItem>
    func dataSourceMaker() -> UICollectionViewDiffableDataSource<String, Constant.OutlineItem> {
        
        let parentRegistration = parentRegistrationMaker()
        let cellRegistration = childRegistrationMaker(indentationLevel: 2)
        
        let diffableDataSource = UICollectionViewDiffableDataSource<String, Constant.OutlineItem>(collectionView: myCollectionView, cellProvider: { collectionView, indexPath, item in
            
            let cell: UICollectionViewListCell
            
            switch item {
            case .parent(let parentItem): cell = collectionView.dequeueConfiguredReusableCell(using: parentRegistration, for: indexPath, item: parentItem)
            case .child(let childItem): cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: childItem)
            }
            
            return cell
        })
        
        return diffableDataSource
    }
    
    /// [產生主項目Cell的註冊資訊 (UICollectionViewListCell)](https://medium.com/彼得潘的-swift-ios-app-開發教室/設定-collection-view-section-header-footer-supplementary-view-的各種方法-f4437caf173b)
    /// - Returns: UICollectionView.CellRegistration<UICollectionViewListCell, Parent>
    func parentRegistrationMaker() -> UICollectionView.CellRegistration<UICollectionViewListCell, Model.Parent> {
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Model.Parent> { cell, indexPath, item in
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = item.item

            cell.tintColor = .black
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }
        
        return registration
    }
    
    /// [產生次項目Cell的註冊資訊 => collectionView(_:cellForItemAt:)](https://juejin.cn/post/7054779926720806942)
    /// - Parameter indentationLevel: 與主項目的間格 (以10pt為一個單位)
    /// - Returns: UICollectionView.CellRegistration<UICollectionViewListCell, Child>
    func childRegistrationMaker(indentationLevel: Int) -> UICollectionView.CellRegistration<UICollectionViewListCell, Model.Child> {
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Model.Child> { cell, indexPath, item in
            
            cell._contentConfiguration(text: item.item, secondaryText: nil, image: nil)
            cell.tintColor = .systemBlue
            cell.indentationLevel = indentationLevel
            cell.accessories = [.reorder(displayed: .always)]
        }
        
        return registration
    }
    
    /// [刪除所選的項目](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-uibackgroundconfiguration-在-collection-view-cell-顯示圖片-7d30e6df1a77)
    /// - Parameter indexPath: IndexPath
    func removeItem(indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
