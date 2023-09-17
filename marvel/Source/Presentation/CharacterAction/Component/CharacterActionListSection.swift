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
    var titleText: String
    var trailingText: String
    
    init(title: String, resource: MVLResourceListData) {
        self.titleText = title
        self.trailingText = String(resource.available)
    }
}

class CharacterActionListCell: MVLAttributedCell<CharacterActionListItem> {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chevronLabel: UILabel!
    @IBOutlet weak var chevronIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .secondarySystemBackground
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        chevronLabel.font = .preferredFont(forTextStyle: .footnote)
        chevronLabel.textColor = .secondaryLabel
    }
    
    override func configure(item: CharacterActionListItem) {
        super.configure(item: item)
        
        titleLabel.text = item.titleText
        chevronLabel.text = item.trailingText
    }
    
}
