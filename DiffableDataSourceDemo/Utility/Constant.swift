//
//  Constant.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit

// MARK: - Constant
final class Constant: NSObject {}

// MARK: - typealias
extension Constant {
    
    typealias MovieInfo = (section: Section, items: [Model.Movie])
}

// MARK: - enum
extension Constant {
    
    enum Section: Int {
        case adventure
        case romance
        case animation
        
        /// 主分類標題
        /// - Returns: String
        func title() -> String {
            
            let title: String
            
            switch self {
            case .adventure: title = "冒險"
            case .romance: title = "浪漫"
            case .animation: title = "動畫"
            }
            
            return title
        }
    }
    
    enum OutlineItem: Hashable {
        case parent(Model.Parent)
        case child(Model.Child)
    }
}
