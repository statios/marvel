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
    
    @IBOutlet weak var favoriteSegueButton: UIBarButtonItem!
    
    @IBSegueAction func prepareFavoriteSegue(_ coder: NSCoder) -> CharacterListViewController? {
        let viewController = CharacterListViewController(coder: coder)
        viewController?.reactor = .init(initialState: .init(context: .favorite))
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
    }
}
