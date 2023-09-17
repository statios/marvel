//
//  CharacterActionThumbnailSection.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import UIKit
import Kingfisher
import Photos

struct CharacterActionThumbnailSection: MVLSection {
    
    typealias Item = CharacterActionThumbnailItem
    
    typealias Cell = CharacterActionThumbnailCell
    
    var items: [CharacterActionThumbnailItem]
    
    var spacing: CGFloat {
        return .zero
    }
    
    var inset: NSDirectionalEdgeInsets {
        return .zero
    }
    
    var itemSize: NSCollectionLayoutSize {
        return .init(widthDimension: .fractionalWidth(1.0),
                     heightDimension: .fractionalWidth(1.0))
    }
}

struct CharacterActionThumbnailItem: Hashable {
    
    var id: String = UUID().uuidString
    var url: URL?
    
    init(resource: MVLImageData) {
        self.url = URL(string: resource.path + "." + resource.`extension`)
    }
}

class CharacterActionThumbnailCell: MVLAttributedCell<CharacterActionThumbnailItem> {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        downloadButton.isHidden = true
        downloadButton.configuration?.title = nil
        downloadButton.configurationUpdateHandler = { (button: UIButton) in
            let iconName = button.isEnabled ? "arrow.down.circle" : "checkmark.circle"
            button.configuration?.image = UIImage(systemName: iconName)?
                .applyingSymbolConfiguration(.init(textStyle: .title1))
        }
            
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.backgroundColor = .secondarySystemBackground
    }
    
    override func configure(item: CharacterActionThumbnailItem) {
        super.configure(item: item)
        
        thumbnailImageView.kf.setImage(with: item.url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success: self.downloadButton.isHidden = false
            case .failure: self.downloadButton.isHidden = true
            }
        }
    }
    
    @IBAction func didTapDownloadButton(_ sender: UIButton) {
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            
            DispatchQueue.main.async {
                self.saveImageOnAlbum(status)
            }
        }
    }
    
    private func saveImageOnAlbum(_ status: PHAuthorizationStatus) {
        
        guard status == .authorized, let image = thumbnailImageView.image else {
            openApplicationSetting()
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = !success
            }
        })
    }
    
    private func openApplicationSetting() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
    }
    
}
