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

extension FetchCharacterListSectionUseCase {
    
}

class FetchAllCharacterListSectionUseCase: FetchCharacterListSectionUseCase {
    
    private let repository = MVLCharacterDataRepository()
    
    private var total = 0
    
    private var offset = 0
    
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
    
    private let repository = MVLCharacterDataRepository()
    
    func loadSection() -> Observable<CharacterListSection> {
        return .never()
    }
    
    func loadMoreSection() -> Observable<CharacterListSection> {
        return .never()
    }
    
    func loadMoreAvailable() -> Bool {
        return true
    }
}

fileprivate extension MVLCharacterListRequest {
    static var `default`: MVLCharacterListRequest {
        return MVLCharacterListRequest(limit: 20)
    }
}
