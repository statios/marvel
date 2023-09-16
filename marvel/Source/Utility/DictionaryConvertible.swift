//
//  DictionaryConvertible.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

protocol DictionaryConvertible {
    func toDictionary() -> [String: Any]
}

extension DictionaryConvertible where Self: Encodable {
    func toDictionary() -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonDictionary
            }
        }
        catch {
            print("Error encoding to JSON: \(error)")
        }
        return [:]
    }
}
