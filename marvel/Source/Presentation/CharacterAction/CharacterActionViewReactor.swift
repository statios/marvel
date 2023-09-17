//
//  CharacterActionViewReactor.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import ReactorKit

class CharacterActionViewReactor: Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setTitle(String?)
        case setSection(any MVLSection)
        case setWebsite(URL?)
        
        case empty
    }
    
    struct State {
        var characterId: Int
        
        var displayLoading: Bool = false
        var displayTitle: String?
        var displaySection: (any MVLSection)?
        var displayWebsite: URL?
    }
    
    var initialState: State
    
    private var characterRepository = MVLCharacterDataRepository()
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case .load:
            
            let request = MVLCharacterRequest(characterId: currentState.characterId)
            let response = characterRepository.fetchCharacter(request).share(replay: 1, scope: .forever)
            
            return .concat([
                .just(.setLoading(true)),
                response.mapTitleMutation(),
                response.mapThumbnailSectionMutation(),
                response.mapListSectionMutation(),
                response.mapWebsiteMutation(),
                .just(.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        newState.displaySection = nil
        
        switch mutation {
        case let .setLoading(loading): newState.displayLoading = loading
        case let .setTitle(title): newState.displayTitle = title
        case let .setSection(section): newState.displaySection = section
        case let .setWebsite(website): newState.displayWebsite = website
        case .empty: break
        }
        
        return newState
    }
    
}

fileprivate typealias Mutation = CharacterActionViewReactor.Mutation

fileprivate extension Observable where Element == MVLCharacterData? {
    
    func mapTitleMutation() -> Observable<Mutation> {
        return map {
            return Mutation.setTitle($0?.name)
        }
    }
    
    func mapThumbnailSectionMutation() -> Observable<Mutation> {
        map { response in
            if let thumbnail = response?.thumbnail {
                let section = CharacterActionThumbnailSection(
                    items: [CharacterActionThumbnailItem(resource: thumbnail)]
                )
                return Mutation.setSection(section)
            }
            return Mutation.empty
        }
    }
    
    func mapListSectionMutation() -> Observable<Mutation> {
        map { response in
            let items: [CharacterActionListItem] = [("Comics", response?.comics),
                         ("Stories", response?.stories),
                         ("Events", response?.events),
                         ("Series", response?.series)]
                .compactMap {
                    guard let resource = $0.1 else { return nil }
                    return CharacterActionListItem(title: $0.0, resource: resource)
                }
            let section = CharacterActionListSection(items: items)
            return Mutation.setSection(section)
        }
    }
    
    func mapWebsiteMutation() -> Observable<Mutation> {
        map { response in
            
            let urlString = response?.urls?.first(where: { $0.type == .wiki })?.url
            ?? response?.urls?.first?.url
            
            if let urlString = urlString,
               let website = URL(string: urlString) {
                return Mutation.setWebsite(website)
            }
            
            return Mutation.setWebsite(nil)
        }
    }
}
