//
//  Extension.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - UITableViewCell (function)
extension UITableViewCell {
    
    /// [設定內建樣式 - iOS 14](https://apppeterpan.medium.com/從-ios-15-開始-使用內建-cell-樣式建議搭配-uilistcontentconfiguration-13d64eb317be)
    /// - Parameters:
    ///   - text: [主要文字](https://zhuanlan.zhihu.com/p/572526799)
    ///   - secondaryText: [次要文字](https://www.jianshu.com/p/e8843595a794)
    ///   - image: [圖示](https://medium.com/@dragos.rotaru9/uitableviewcell-in-ios-14-ef19e877319f)
    func _defaultContentConfiguration(text: String?, secondaryText: String?, image: UIImage?) {
        
        var config = defaultContentConfiguration()
                
        config.text = text
        config.secondaryText = secondaryText
        config.image = image
        
        contentConfiguration = config
    }
}

// MARK: - UICollectionViewListCell (function)
extension UICollectionViewListCell {
    
    /// [設定可折疊Cell的內建樣式 - iOS 14](https://www.appcoda.com.tw/ios-14-uicollectionview/)
    /// - Parameters:
    func _defaultContentConfiguration(text: String?, secondaryText: String?, image: UIImage?) {
        
        var config = defaultContentConfiguration()
        
        config.text = text
        config.image = image
        config.secondaryText = secondaryText
        
        contentConfiguration = config
    }
}

// MARK: - UICollectionLayoutListConfiguration
extension UICollectionLayoutListConfiguration {
    
    /// [產生UICollectionLayoutListConfiguration](https://www.appcoda.com.tw/ios-14-uicollectionview/)
    /// - Parameters:
    ///   - appearance: [UICollectionLayoutListConfiguration.Appearance](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/把-collection-view-變成-table-view-的形狀-uicollectionlayoutlistconfiguration-7c83a6b20261)
    ///   - backgroundColor: UIColor?
    /// - Returns: UICollectionLayoutListConfiguration
    static func _build(appearance: UICollectionLayoutListConfiguration.Appearance, backgroundColor: UIColor? = nil) -> UICollectionLayoutListConfiguration {
        
        var config = UICollectionLayoutListConfiguration(appearance: appearance)
        config.backgroundColor = backgroundColor
        
        return config
    }
}

// MARK: - UICellAccessory.CustomViewConfiguration (function)
extension UICellAccessory.CustomViewConfiguration {
    
    /// [Cell上的自訂Accessory](https://www.donnywals.com/how-to-add-a-custom-accessory-to-a-uicollectionviewlistcell/)
    /// - Parameters:
    ///   - customView: UIView
    ///   - placement: UICellAccessory.Placement
    ///   - tintColor: UIColor?
    /// - Returns: UICellAccessory.CustomViewConfiguration
    static func _build(customView: UIView, placement: UICellAccessory.Placement, tintColor: UIColor?) -> Self {
        let customAccessory = Self(customView: customView, placement: placement, tintColor: tintColor)
        return customAccessory
    }
}

// MARK: - UISwipeActionsConfiguration (static function)
extension UISwipeActionsConfiguration {
    
    /// [滑動按鈕設定](https://anny86023.medium.com/uitableview-swipe-action-客製化滑動按鈕動作-7b9e90155815)
    /// - Parameters:
    ///   - actions: [UIContextualAction]
    ///   - performsFirstActionWithFullSwipe: 防止cell滑到底之後，不小心觸發第一個按鈕
    static func _build(actions: [UIContextualAction], performsFirstActionWithFullSwipe: Bool = false) -> UISwipeActionsConfiguration {
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = performsFirstActionWithFullSwipe
        
        return configuration
    }
}

// MARK: - UICollectionView (static function)
extension UIContextualAction {
    
    /// [產生TableView滑動按鈕](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/客製表格-table-的-swipe-action-bed0a8bf7979)
    /// - tableView(_:leadingSwipeActionsConfigurationForRowAt:) / tableView(_:trailingSwipeActionsConfigurationForRowAt:)
    /// - Parameters:
    ///   - title: 標題
    ///   - style: 格式
    ///   - color: 底色
    ///   - image: 背景圖
    ///   - function: 功能
    /// - Returns: UIContextualAction
    static func _build(with title: String? = nil, style: UIContextualAction.Style = .normal, color: UIColor = .gray, image: UIImage? = nil, function: @escaping (() -> Void)) -> UIContextualAction {
        
        let contextualAction = UIContextualAction(style: style, title: title, handler: { (action, view, headler) in
            function()
            headler(true)
        })
        
        contextualAction.backgroundColor = color
        contextualAction.image = image
        
        return contextualAction
    }
}
