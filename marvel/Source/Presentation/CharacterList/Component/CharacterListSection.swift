//
//  CharacterListSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import UIKit
import Kingfisher

struct CharacterListSection: MVLSection {
    
    typealias Item = CharacterListItem
    
    typealias Cell = CharacterListCell
    
    var items: [CharacterListItem]
    
    var spacing: CGFloat {
        return 1
    }
    
    var inset: NSDirectionalEdgeInsets {
        return .zero
    }
}

struct CharacterListItem: Hashable {
    
    var id: Int
    var thumbnail: URL?
    var nameText: String
    var bodyText: String
    
    init(resource: MVLCharacterData) {
        self.id = resource.id
        
        if let path = resource.thumbnail?.path,
           let ext = resource.thumbnail?.extension {
            self.thumbnail = URL(string: path + "." + ext)
        }
        
        self.nameText = resource.name
        self.bodyText = [
            ("Sites", resource.urls?.count),
            ("Comics", resource.comics?.available),
            ("Stories", resource.stories?.available),
            ("Events", resource.events?.available),
            ("Series", resource.series?.available)
        ]
            .compactMap {
                guard let count = $0.1 else { return nil }
                return "· \(count) \($0.0)"
            }
            .joined(separator: "\n")
    }
}

class CharacterListCell: MVLAttributedCell<CharacterListItem> {
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteIcon: String {
        return favoriteButton.isSelected ? "star.fill" : "star"
    }
    
    private let favoriteCharacterUseCase = ManageFavoriteCharacterUseCase()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.backgroundColor = .secondarySystemFill
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        favoriteButton.configuration?.title = nil
        favoriteButton.configurationUpdateHandler = { [weak self] (button: UIButton) in
            guard let self else { return }
            button.configuration?.image = UIImage(systemName: self.favoriteIcon)
        }
        favoriteButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.reconfigure()
        }), for: .touchUpInside)
        
        bodyLabel.numberOfLines = 0
        bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        containerView.backgroundColor = .secondarySystemBackground
    }
    
    override func configure(item: CharacterListItem) {
        super.configure(item: item)
        
        thumbnailImageView.kf.setImage(with: item.thumbnail)
        nameLabel.text = item.nameText
        favoriteButton.isSelected = favoriteCharacterUseCase
            .fetchFavoriteCharacterList()
            .contains(item.id)
        bodyLabel.text = item.bodyText
    }
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        favoriteCharacterUseCase.updateFavoriteCharacter(item.id)
        notify(event: .favorite)
        reconfigure()
    }
    
}
