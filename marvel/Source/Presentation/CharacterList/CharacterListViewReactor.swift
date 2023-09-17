//
//  CharacterListViewReactor.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation
import ReactorKit

class CharacterListViewReactor: Reactor {
    
    private let fetchSectionUseCase: FetchCharacterListSectionUseCase
    
    enum Context {
        case all, favorite
        
        var title: String {
            switch self {
            case .all: return "All"
            case .favorite: return "Favorites"
            }
        }
        
        func createSectionFetcher() -> FetchCharacterListSectionUseCase {
            switch self {
            case .all: return FetchAllCharacterListSectionUseCase()
            case .favorite: return FetchFavoriteCharacterListSectionUseCase()
            }
        }
    }
    
    enum Action {
        case load, loadMore
        case selectFavoriteItem(CharacterListItem)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSection(any MVLSection)
        case setSectionAppend(CharacterListSection)
        case setDeleteItems([AnyHashable])
        case setMoreAlert(MVLAlertItem)
    }
    
    struct State {
        
        var context: Context
        
        var displayTitle: String { context.title }
        var displayLoading = false
        var displayFavoriteSegueButton: Bool { context == .all }
        var displayFavoriteSegueButtonTitle: String? {
            guard displayFavoriteSegueButton else { return nil }
            return Context.favorite.title
        }
        var displaySection: (any MVLSection)?
        var displaySectionAppend: (CharacterListSection)?
        var displayDeleteItems: [AnyHashable]?
        var displayMoreAlert: MVLAlertItem?
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
        self.fetchSectionUseCase = initialState.context.createSectionFetcher()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case .load:
            
            let response = fetchSectionUseCase.loadSection()
            
            return .concat([
                .just(.setLoading(true)),
                response.mapSectionMutation(),
                .just(.setLoading(false))
            ])
            
        case .loadMore:
            
            guard !currentState.displayLoading else { return .empty()}
            
            if !fetchSectionUseCase.loadMoreAvailable(), currentState.context == .all {
                return Observable.just(.setMoreAlert(.plain("No more items to load.")))
                    .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            }
            
            let response = fetchSectionUseCase.loadMoreSection()
            
            return .concat([
                .just(.setLoading(true)),
                response.mapSectionAppendMutation(),
                .just(.setLoading(false))
            ])
            
        case let .selectFavoriteItem(item):
            
            guard currentState.context == .favorite else { return .empty() }
            
            return .just(.setDeleteItems([item]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.displaySection = nil
        newState.displaySectionAppend = nil
        newState.displayDeleteItems = nil
        newState.displayMoreAlert = nil
        
        switch mutation {
            
        case let .setLoading(loading): newState.displayLoading = loading
        case let .setSection(section): newState.displaySection = section
        case let .setSectionAppend(section): newState.displaySectionAppend = section
        case let .setDeleteItems(items): newState.displayDeleteItems = items
        case let .setMoreAlert(item): newState.displayMoreAlert = item
        }
        
        return newState
    }
    
}

fileprivate typealias Mutation = CharacterListViewReactor.Mutation

fileprivate extension Observable where Element == CharacterListSection {
    
    func mapSectionMutation() -> Observable<Mutation> {
        return map {
            return Mutation.setSection($0)
        }
    }
    
    func mapSectionAppendMutation() -> Observable<Mutation> {
        return map {
            return Mutation.setSectionAppend($0)
        }
    }
}
