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
    }
    
    enum OutlineItem: Hashable {
        case parent(Model.Parent)
        case child(Model.Child)
    }
}
