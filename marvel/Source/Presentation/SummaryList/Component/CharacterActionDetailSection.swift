//
//  SummaryListSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import UIKit

struct CharacterActionDetailSection: MVLSection {
    
    typealias Item = CharacterActionDetailItem
    
    typealias Cell = CharacterActionDetailCell
    
    var items: [CharacterActionDetailItem]
    
    var spacing: CGFloat {
        return 1
    }
    
    var inset: NSDirectionalEdgeInsets {
        return .zero
    }
}

struct CharacterActionDetailItem: Hashable {
    
    var id = UUID().uuidString
    var title: String
    
    init(resource: AnyMVLSummaryRepresentable) {
        self.title = resource.name
    }
}

class CharacterActionDetailCell: MVLAttributedCell<CharacterActionDetailItem> {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .secondarySystemBackground
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
    }
    
    override func configure(item: CharacterActionDetailItem) {
        super.configure(item: item)
        
        titleLabel.text = item.title
    }
    
}
