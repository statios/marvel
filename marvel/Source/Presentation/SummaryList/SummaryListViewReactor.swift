//
//  SummaryListViewReactor.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import ReactorKit

class SummaryListViewReactor: Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setSection(any MVLSection)
    }
    
    struct State {
        var resource: CharacterActionListItem
        
        var displayTitle: String {
            return resource.title
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
            let items = currentState.resource.resource.items.map {
                SummaryListItem(resource: $0)
            }
            let section = SummaryListSection(items: items)
            return .just(.setSection(section))
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.displaySection = nil
        
        switch mutation {
        case let .setSection(section): newState.displaySection = section
        }
        
        return newState
    }
    
}

