//
//  MVLJSONDecoder.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation

extension JSONDecoder {
    static var MLVJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
