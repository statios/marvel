//
//  MVLCell.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit

protocol MVLSectionEventListener: AnyObject {
    func didReceive(event: MVLSectionEventKey, sectionIdentifier: String, itemIdentifier: AnyHashable)
}

struct MVLSectionEventKey: Hashable, Equatable, RawRepresentable {
    let rawValue: String

    static let favorite = MVLSectionEventKey(rawValue: "favorite")
}

class MVLCell: UICollectionViewCell {
    
    var sectionIdentifier: String!
    var itemIdentifier: AnyHashable!
    
    weak var listener: MVLSectionEventListener?
    
    func configure(item: AnyHashable) {
        self.itemIdentifier = item
    }
    
    final func notify(event: MVLSectionEventKey) {
        listener?.didReceive(event: event, sectionIdentifier: sectionIdentifier, itemIdentifier: itemIdentifier)
    }
    
    final func reconfigure() {
        if itemIdentifier != .none {
            configure(item: itemIdentifier)
        }
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

}
