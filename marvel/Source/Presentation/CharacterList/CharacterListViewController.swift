//
//  CharacterListViewController.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation
import UIKit
import ReactorKit
import RxCocoa

final class CharacterListViewController: MVLViewController, StoryboardView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var favoriteSegueButton: UIBarButtonItem!
    
    override var targetCollectionView: UICollectionView? {
        return collectionView
    }
    
    override var useRefreshCellViewDidAppeared: Bool {
        return true
    }
    
    @IBSegueAction func prepareFavoriteSegue(_ coder: NSCoder) -> CharacterListViewController? {
        let viewController = CharacterListViewController(coder: coder)
        viewController?.reactor = .init(initialState: .init(context: .favorite))
        return viewController
    }
    
    @IBSegueAction func prepareActionSegue(_ coder: NSCoder, sender: Any?) -> CharacterActionViewController? {
        let viewController = CharacterActionViewController(coder: coder)
        if let cell = sender as? CharacterListCell {
            viewController?.reactor = .init(initialState: .init(characterId: cell.item.id))
        }
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if reactor == nil {
            reactor = .init(initialState: .init(context: .all))
        }
        reactor?.action.onNext(.load)
    }
    
    func bind(reactor: CharacterListViewReactor) {
        
        reactor.state.map { $0.displayLoading }
            .distinctUntilChanged()
            .bind(to: rx.loading)
            .disposed(by: disposeBag)
        
        reactor.state.map { !$0.displayFavoriteSegueButton }
            .distinctUntilChanged()
            .bind(to: favoriteSegueButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayTitle }
            .distinctUntilChanged()
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayFavoriteSegueButtonTitle }
            .distinctUntilChanged()
            .bind(to: favoriteSegueButton.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.displaySection }
            .bind(to: rx.section)
            .disposed(by: disposeBag)
    }
}
