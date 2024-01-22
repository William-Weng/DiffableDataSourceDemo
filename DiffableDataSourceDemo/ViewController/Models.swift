//
//  Model.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit

// MARK: - Model
final class Model: NSObject {
    
    // MARK: - 電影內容資訊
    struct Movie: Hashable {
        
        let uuid = UUID()   // 以UUID為hash值 (防止一樣的資料不能新增)
        
        var name: String
        var actor: String
        var year: Int
                
        static func ==(lhs: Movie, rhs: Movie) -> Bool { return lhs.uuid == rhs.uuid }
        
        func hash(into hasher: inout Hasher) { hasher.combine(uuid) }
    }
    
    /// 主分類
    struct Parent: Hashable {
        let item: String
        let childItems: [Child]
    }
    
    /// 次分類
    struct Child: Hashable {
        let item: String
    }
}
