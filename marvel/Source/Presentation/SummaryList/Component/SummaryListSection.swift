//
//  SummaryListSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import UIKit

struct SummaryListSection: MVLSection {
    
    typealias Item = SummaryListItem
    
    typealias Cell = SummaryListCell
    
    var items: [SummaryListItem]
    
    var spacing: CGFloat {
        return 1
    }
    
    var inset: NSDirectionalEdgeInsets {
        return .zero
    }
}

struct SummaryListItem: Hashable {
    
    var id = UUID().uuidString
    var title: String
    
    init(resource: AnyMVLSummaryRepresentable) {
        self.title = resource.name
    }
}

class SummaryListCell: MVLAttributedCell<SummaryListItem> {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .secondarySystemBackground
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
    }
    
    override func configure(item: SummaryListItem) {
        super.configure(item: item)
        
        titleLabel.text = item.title
    }
    
}
