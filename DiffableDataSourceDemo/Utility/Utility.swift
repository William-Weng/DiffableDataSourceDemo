//
//  Utility.swift
//  DiffableDataSourceDemo
//
//  Created by iOS on 2024/1/23.
//

import Foundation

// MARK: - 工具集
final class Utility: NSObject {
    
    private override init() {}
    static let shared = Utility()
}

// MARK: - 小工具
extension Utility {
    
    /// 產生假資料
    /// - Returns: [MovieInfo]
    func movieInfoMaker() -> [Constant.MovieInfo] {
        
        let adventureMovies = [
            Model.Movie(name: "蜘蛛人:返校日", actor: "湯姆", year: 2017),
            Model.Movie(name: "蜘蛛人:驚奇再起", actor: "安德魯", year: 2012),
            Model.Movie(name: "蜘蛛人", actor: "陶比", year: 2002)
        ]
        
        let romanceMovies = [
            Model.Movie(name: "生命中的美好缺憾", actor: "雪琳", year: 2014),
            Model.Movie(name: "真愛每一天", actor: "瑞秋", year: 2013),
            Model.Movie(name: "手札情緣", actor: "雷恩", year: 2004)
        ]
        
        let animationMovies = [
            Model.Movie(name: "龍貓", actor: "宮崎駿", year: 1988),
            Model.Movie(name: "地海戰記", actor: "宮崎吾朗", year: 2006),
            Model.Movie(name: "鈴芽之旅", actor: "新海誠", year: 2022)
        ]
        
        let moviesInfo: [Constant.MovieInfo] = [
            (section: .adventure, items: adventureMovies),
            (section: .romance, items: romanceMovies),
            (section: .animation, items: animationMovies),
        ]
        
        return moviesInfo
    }
}
