//
//  CharacterActionViewController.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit
import ReactorKit
import SafariServices

final class CharacterActionViewController: MVLViewController, StoryboardView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var websiteButton: UIBarButtonItem!
    
    override var targetCollectionView: UICollectionView? {
        return collectionView
    }
    
    override var sectionSpacing: CGFloat {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        websiteButton.title = "Website"
        websiteButton.isHidden = true
        
        reactor?.action.onNext(.load)
    }
    
    func bind(reactor: CharacterActionViewReactor) {
        
        reactor.state.map { $0.displayLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayTitle }
            .distinctUntilChanged()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.displaySection }
            .bind(to: rx.section)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayWebsite == .none }
            .distinctUntilChanged()
            .bind(to: websiteButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @IBAction func didTapWebsiteButton(_ sender: UIBarButtonItem) {
        
        guard let website = reactor?.currentState.displayWebsite else { return }
        
        let viewController = SFSafariViewController(url: website)
        present(viewController, animated: true)
    }
}

