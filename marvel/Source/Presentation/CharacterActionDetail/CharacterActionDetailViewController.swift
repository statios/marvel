//
//  SummaryListViewController.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import UIKit
import ReactorKit

final class CharacterActionDetailViewController: MVLViewController, StoryboardView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var targetCollectionView: UICollectionView? {
        return collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor?.action.onNext(.load)
    }
    
    func bind(reactor: CharacterActionDetailViewReactor) {
        
        reactor.state.map { $0.displayTitle }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.displaySection }
            .bind(to: rx.section)
            .disposed(by: disposeBag)
    }
}

