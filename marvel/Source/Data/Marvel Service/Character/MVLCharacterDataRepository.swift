//
//  MVLCharacterDataRepository.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation
import RxSwift

protocol MVLCharacterDataSource {
    func fetchCharacterList(_ request: MVLCharacterListRequest) -> Single<MVLDataContainer<MVLCharacterData>>
    func fetchCharacter(_ request: MVLCharacterRequest) -> Single<MVLDataContainer<MVLCharacterData>>
}

class MVLCharacterDataRepository {
    
    private var remoteDataSource: MVLCharacterDataSource = MVLCharacterRemoteDataSource()
    
    func fetchCharacterList(_ request: MVLCharacterListRequest) -> Observable<MVLDataContainer<MVLCharacterData>> {
        return Observable.merge(
            remoteDataSource.fetchCharacterList(request).asObservable()
        )
    }
    
    func fetchCharacter(_ request: MVLCharacterRequest) -> Observable<MVLDataContainer<MVLCharacterData>> {
        return Observable.merge(
            remoteDataSource.fetchCharacter(request).asObservable()
        )
    }
}
