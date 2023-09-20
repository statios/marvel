//
//  ErrorHandlings.swift
//  marvel
//
//  Created by stat on 2023/09/20.
//

import Foundation
import Moya
import RxMoya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element: Response {
    
    func throwMappedError<D: DecodableError>(_ type: D.Type, using decoder: JSONDecoder) -> PrimitiveSequence<Trait, Element> {
        self.flatMap { response in
            guard (200...299).contains(response.statusCode) else {
                do {
                    let failureResponse = try response.map(type, using: decoder)
                    throw failureResponse
                }
                catch {
                    throw error
                }
            }
            return .just(response)
        }
    }
}

protocol DecodableError: Decodable, Error {
    
}
