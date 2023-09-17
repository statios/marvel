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
    
    var title: String
    
    var trailingText: String {
        return String(resource.available)
    }
    
    var resource: MVLResourceListData
    
    init(title: String, resource: MVLResourceListData) {
        self.title = title
        self.resource = resource
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: CharacterActionListItem, rhs: CharacterActionListItem) -> Bool {
        return lhs.title == rhs.title
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
        
        titleLabel.text = item.title
        chevronLabel.text = item.trailingText
    }
    
}
