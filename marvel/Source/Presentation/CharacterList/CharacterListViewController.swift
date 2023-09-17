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
        
        registerSectionEventHandler(CharacterListSection.self, event: .favorite) { [weak self] item in
            
            guard let self else { return }
            self.reactor?.action.onNext(.selectFavoriteItem(item))
        }
        
        reactor?.action.onNext(.load)
    }
    
    override func collectionView(sectionIdentifier: String, willDisplay lastCell: MVLCell) {
        super.collectionView(sectionIdentifier: sectionIdentifier, willDisplay: lastCell)
        
        reactor?.action.onNext(.loadMore)
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
        
        reactor.state.compactMap { $0.displaySectionAppend }
            .bind(to: rx.sectionAppend)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.displayDeleteItems }
            .bind(to: rx.deleteItems)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.displayMoreAlert }.take(1)
            .bind(to: rx.alert)
            .disposed(by: disposeBag)
    }
    
    fileprivate func appendSection(_ section: CharacterListSection) {
        guard var newSection = sections.first(where: { $0.id == section.id }) as? CharacterListSection else { return }
        newSection.items.append(contentsOf: section.items)
        applySection(newSection)
    }
}

extension Reactive where Base: CharacterListViewController {
    var sectionAppend: Binder<CharacterListSection> {
        Binder(base) { base, newValue in
            base.appendSection(newValue)
        }
    }
}
