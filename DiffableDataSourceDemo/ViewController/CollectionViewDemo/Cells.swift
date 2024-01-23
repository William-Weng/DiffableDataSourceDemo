//
//  Cells.swift
//  DiffableDataSourceDemo
//
//  Created by iOS on 2024/1/23.
//

import UIKit

final class WWCollectionViewListCell: UICollectionViewListCell {
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        super.updateConfiguration(using: state)
        self.contentConfiguration = configuration(using: state, expandedImage: UIImage(named: "Down"), reducedImage: UIImage(named: "Up"))
    }
}

private extension WWCollectionViewListCell {
    
    /// [自訂折疊的圖示](https://www.donnywals.com/how-to-add-a-custom-accessory-to-a-uicollectionviewlistcell/)
    /// - Parameters:
    ///   - state: UICellConfigurationState
    ///   - expandedImage: UIImage?
    ///   - reducedImage: UIImage?
    /// - Returns: UIListContentConfiguration?
    func configuration(using state: UICellConfigurationState, expandedImage: UIImage?, reducedImage: UIImage?) -> UIListContentConfiguration? {
       
        guard var config = self.contentConfiguration?.updated(for: state) as? UIListContentConfiguration else { return nil }
        
        config.image = state.isExpanded ? expandedImage : reducedImage
        config.imageProperties.reservedLayoutSize = CGSize(width: 12.0, height: 12.0)
        config.imageToTextPadding = 16.0
        
        return config
    }
}
