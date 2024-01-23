//
//  CollectionViewDemoController.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit
import WWPrint

// MARK: - 電影列表 (折疊)
final class CollectionViewDemoController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<String, Constant.OutlineItem> = dataSourceMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting(appearance: .insetGrouped)
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewDemoController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        wwPrint(item)
    }
}

// MARK: - 小工具
private extension CollectionViewDemoController {
    
    /// [初始化設定](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/方便排版的-uicollectionviewcompositionallayout-初體驗-ab0c81ffecf6)
    /// - Parameter appearance: [Layout樣式](https://www.appcoda.com.tw/ios-14-diffable-data-source/)
    func initSetting(appearance: UICollectionLayoutListConfiguration.Appearance) {
        
        let config = UICollectionLayoutListConfiguration._build(appearance: appearance, backgroundColor: .clear)
        let snapshot = sectionSnapshotMaker()

        myCollectionView.delegate = self
        myCollectionView.dataSource = dataSource                                                            // 取代 myCollectionView.dataSource = self
        myCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        
        dataSource.apply(snapshot, to: "Root", animatingDifferences: true, completion: nil)                 // 取代 reloadData() / reloadSections() / reloadItems(at:)
        dataSourceReorderingHandlers()
    }
    
    /// [產生資料源 = Cell長相 + 項目資料 (dequeueConfiguredReusableCell)](https://juejin.cn/post/6850418106381434894)
    /// => collectionView(_:numberOfItemsInSection:) + collectionView(_:cellForItemAt:)
    /// - Returns: [UICollectionViewDiffableDataSource<String, OutlineItem>](https://useyourloaf.com/blog/button-configuration-in-ios-15/)
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
}

// MARK: - 小工具
private extension CollectionViewDemoController {
    
    /// [產生主項目Cell的註冊資訊 (UICollectionViewListCell)](https://medium.com/彼得潘的-swift-ios-app-開發教室/設定-collection-view-section-header-footer-supplementary-view-的各種方法-f4437caf173b)
    /// - Returns: [UICollectionView.CellRegistration<WWCollectionViewListCell, Parent>](https://www.donnywals.com/how-to-add-a-custom-accessory-to-a-uicollectionviewlistcell/)
    func parentRegistrationMaker() -> UICollectionView.CellRegistration<WWCollectionViewListCell, Model.Parent> {
        
        let registration = UICollectionView.CellRegistration<WWCollectionViewListCell, Model.Parent> { cell, indexPath, parent in
            
            let disclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .cell, tintColor: .black)
            let customView = UICellAccessory.CustomViewConfiguration._build(customView: UIImageView(image: UIImage(systemName: "paperplane")), placement: .leading(displayed: .always), tintColor: .red)
            
            cell._defaultContentConfiguration(text: parent.item.title(), secondaryText: nil, image: nil)
            cell.accessories = [.customView(configuration: customView), .outlineDisclosure(options: disclosureOption), .delete()]
        }
        
        return registration
    }
    
    /// [產生次項目Cell的註冊資訊 => collectionView(_:cellForItemAt:)](https://juejin.cn/post/7054779926720806942)
    /// - Parameter indentationLevel: [與主項目的間格 (以10pt為一個單位)](https://www.gushiciku.cn/pl/pXoE/zh-hk)
    /// - Returns: [UICollectionView.CellRegistration<UICollectionViewListCell, Child>](https://sujinnaljin.medium.com/ios-uicellaccessory-종류-알아보기-335d3f4a1f3c )
    func childRegistrationMaker(indentationLevel: Int) -> UICollectionView.CellRegistration<UICollectionViewListCell, Model.Child> {
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Model.Child> { cell, indexPath, child in
            
            cell._defaultContentConfiguration(text: child.item, secondaryText: nil, image: nil)
            cell.indentationLevel = indentationLevel
            cell.accessories = [.reorder(displayed: .always)]
        }
        
        return registration
    }
}

// MARK: - 小工具
private extension CollectionViewDemoController {
    
    /// [設定Header + Cells間的關係 / 用Identify來當reloadData的Key比對之用](https://juejin.cn/post/6908885450744823821)
    /// - Returns: [NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>](https://www.jianshu.com/p/3c17b0f6011f)
    func sectionSnapshotMaker() -> NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem> {
        
        let hirerachicalInformations = hirerachicalInformationsMaker()
        var snapshot = NSDiffableDataSourceSectionSnapshot<Constant.OutlineItem>()
        
        for info in hirerachicalInformations {
            
            let header = Constant.OutlineItem.parent(info)
            let cells = info.childItems.map { Constant.OutlineItem.child($0) }
            
            snapshot.append([header])
            snapshot.append(cells, to: header)
            
            switch info.item {
            case .adventure: snapshot.expand([header])
            case .romance: break
            case .animation: break
            }
        }
        
        return snapshot
    }
    
    /// [階層式資料 -> 折疊 (測試資料)](https://www.jianshu.com/p/35fdf7899128)
    /// => [Parent + [Child, Child, Child, Child, Child]]
    /// - Returns: [Parent]
    func hirerachicalInformationsMaker() -> [Model.Parent] {
        
        let moviesInfo = Utility.shared.movieInfoMaker()
        
        let infos = moviesInfo.map {
            let info = Model.Parent(item: $0.section, childItems: $0.items.map { Model.Child(item: $0.name) })
            return info
        }
        
        return infos
    }
}

// MARK: - 小工具
private extension CollectionViewDemoController {
    
    /// [當Item在移動時的處理](https://medium.com/@le821227/diffable-datasource-for-uitableview-uicollectionview-6c4436362ae6)
    func dataSourceReorderingHandlers() {
        
        dataSource.reorderingHandlers.canReorderItem = { item in
            return true
        }
        
        dataSource.reorderingHandlers.didReorder = { transaction in
            wwPrint(transaction.difference)
        }
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
