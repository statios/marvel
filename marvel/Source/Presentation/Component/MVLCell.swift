//
//  MVLCell.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit

class MVLCell: UICollectionViewCell {
    
    var itemIdentifier: AnyHashable!
    
    func configure(item: AnyHashable) {
        self.itemIdentifier = item
    }
}

class MVLAttributedCell<Item: Hashable>: MVLCell {
    
    var item: Item {
        return itemIdentifier as! Item
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    final override func configure(item: AnyHashable) {
        super.configure(item: item)

        if let item = item as? Item {
            configure(item: item)
        }
    }

    func configure(item: Item) {
        
    }

    final func reconfigure() {
        if itemIdentifier != .none {
            configure(item: itemIdentifier)
        }
    }

}
