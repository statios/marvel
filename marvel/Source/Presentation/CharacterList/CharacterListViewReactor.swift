//
//  CharacterListViewReactor.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation
import ReactorKit

class CharacterListViewReactor: Reactor {
    
    private let characterRepository = MVLCharacterDataRepository()
    
    enum Context {
        case all, favorite
        
        var title: String {
            switch self {
            case .all: return "All"
            case .favorite: return "Favorites"
            }
        }
    }
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSection(any MVLSection)
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
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case .load:
            
            let section = characterRepository
                .fetchCharacterList(MVLCharacterListRequest())
                .map { response in
                    CharacterListSection(
                        items: response.results.map {
                            CharacterListItem(resource: $0)
                        }
                    )
                }
                .map { Mutation.setSection($0) }
            
            return .concat([
                .just(.setLoading(true)),
                section,
                .just(.setLoading(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.displaySection = nil
        
        switch mutation {
            
        case let .setLoading(loading): newState.displayLoading = loading
        case let .setSection(section): newState.displaySection = section
        }
        
        return newState
    }
    
}

