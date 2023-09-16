//
//  MVLCharacterDataSource.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation
import RxSwift
import Moya
import RxMoya

struct MVLCharacterRemoteDataSource: MVLCharacterDataSource {
    
    private enum Target: MVLTargetType {
        
        case characterList(MVLCharacterListRequest)
        case character(MVLCharacterRequest)
        
        var path: String {
            switch self {
            case .characterList: return "/v1/public/characters"
            case let .character(request): return "/v1/public/characters/\(request.characterId)"
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .characterList: return .get
            case .character: return .get
            }
        }
        
        var task: Moya.Task {
            
            switch self {
                
            case let .characterList(request):
                return .requestParameters(
                    parameters: request.toDictionary(),
                    encoding: URLEncoding.queryString
                )
                
            case .character: return .requestPlain
            }
        }
    }
    
    private var provider = MoyaProvider<Target>()
    
    func fetchCharacterList(_ request: MVLCharacterListRequest) -> Single<MVLDataContainer<MVLCharacterData>> {
        return provider.rx.request(.characterList(request))
            .map(MVLResult<MVLCharacterData>.self, using: .MLVJSONDecoder)
            .map { $0.data }
    }
    
    func fetchCharacter(_ request: MVLCharacterRequest) -> Single<MVLDataContainer<MVLCharacterData>> {
        return provider.rx.request(.character(request))
            .map(MVLResult<MVLCharacterData>.self, using: .MLVJSONDecoder)
            .map { $0.data }
    }
}
