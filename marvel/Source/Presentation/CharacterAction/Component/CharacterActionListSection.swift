//
//  CharacterActionListSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import UIKit

struct CharacterActionListSection: MVLSection {
    
    typealias Item = CharacterActionListItem
    
    typealias Cell = CharacterActionListCell
    
    var items: [CharacterActionListItem]
    
    var spacing: CGFloat {
        return 1
    }
    
    var inset: NSDirectionalEdgeInsets {
        return .zero
    }
    
}

struct CharacterActionListItem: Hashable {
    
}

class CharacterActionListCell: MVLAttributedCell<CharacterActionListItem> {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure(item: CharacterActionListItem) {
        super.configure(item: item)
    }
    
}
