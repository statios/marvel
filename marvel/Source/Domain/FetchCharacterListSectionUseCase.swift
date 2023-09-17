//
//  MakeCharacterListSectionUseCase.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation
import RxSwift

protocol FetchCharacterListSectionUseCase {
    func loadSection() -> Observable<CharacterListSection>
    func loadMoreSection() -> Observable<CharacterListSection>
    func loadMoreAvailable() -> Bool
}

class FetchAllCharacterListSectionUseCase: FetchCharacterListSectionUseCase {
    
    private let repository = MVLCharacterDataRepository()
    
    private var total: Int = .zero
    
    private var offset: Int = .zero
    
    private func updatePaginationRelated(_ container: MVLDataContainer<MVLCharacterData>) {
        total = container.total
        offset = container.offset + container.count
    }
    
    func loadSection() -> Observable<CharacterListSection> {
        
        return repository
            .fetchCharacterList(.default)
            .do { [weak self] container in
                guard let self else { return }
                self.updatePaginationRelated(container)
            }
            .map { response in
                CharacterListSection(
                    items: response.results.map {
                        CharacterListItem(resource: $0)
                    }
                )
            }
    }
    
    func loadMoreSection() -> Observable<CharacterListSection> {
        var request = MVLCharacterListRequest.default
        request.offset = offset
        
        return repository
            .fetchCharacterList(request)
            .do { [weak self] container in
                guard let self else { return }
                self.updatePaginationRelated(container)
            }
            .map { response in
                CharacterListSection(
                    items: response.results.map {
                        CharacterListItem(resource: $0)
                    }
                )
            }
    }
    
    func loadMoreAvailable() -> Bool {
        return offset < total
    }
}

class FetchFavoriteCharacterListSectionUseCase: FetchCharacterListSectionUseCase {
    
    private var favoriteUseCase = ManageFavoriteCharacterUseCase()
    
    private let repository = MVLCharacterDataRepository()
    
    private lazy var paginationQueue = favoriteUseCase.fetchFavoriteCharacterList()
    
    private func dequeuePaginationItems(_ size: Int) -> [Int] {
        let result = Array(paginationQueue.prefix(size))
        paginationQueue.removeFirst(result.count)
        return result
    }
    
    private var paginationSize: Int {
        return 20
    }
    
    func loadSection() -> Observable<CharacterListSection> {
        
        let responses = dequeuePaginationItems(paginationSize).map {
            repository.fetchCharacter(MVLCharacterRequest(characterId: $0))
        }
        
        if responses.isEmpty {
            return .just(CharacterListSection(items: []))
        }
        
        return Observable.zip(responses)
            .map { characters -> CharacterListSection in
                let items = characters.compactMap { character -> CharacterListItem? in
                    guard let resource = character else { return nil }
                    return CharacterListItem(resource: resource)
                }
                return CharacterListSection(items: items)
            }
    }
    
    func loadMoreSection() -> Observable<CharacterListSection> {
        return loadSection()
    }
    
    func loadMoreAvailable() -> Bool {
        return !paginationQueue.isEmpty
    }
}

fileprivate extension MVLCharacterListRequest {
    static var `default`: MVLCharacterListRequest {
        return MVLCharacterListRequest(limit: 20)
    }
}
