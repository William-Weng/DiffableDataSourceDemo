//
//  MovieDetailViewController.swift
//  DiffableDataSourceDemo
//
//  Created by William.Weng on 2024/1/22.
//

import UIKit

// MARK: - 電影詳細資訊
final class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    var movie: Model.Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    /// 初始化
    func initSetting() {
        yearLabel.text = "\(movie?.year ?? 1911)"
        nameLabel.text = movie?.name
        actorLabel.text = movie?.actor
    }
}
