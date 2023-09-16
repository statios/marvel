//
//  MVLTargetType.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

/*
 References
 https://developer.marvel.com/documentation/authorization
 */

import Foundation
import Moya

protocol MVLTargetType: TargetType {
    
}

extension MVLTargetType {
    
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/")!
    }
    
    var headers: [String : String]? {
        
        guard let plistPath = Bundle.main.path(forResource: "SecretInfo", ofType: "plist"),
              let plistURL = URL(string: plistPath),
              let dictionary = NSDictionary(contentsOf: plistURL),
              let marvelInfo = dictionary["Marvel Comics API Information"] as? [String: String],
              let publicKey = marvelInfo["Private Key"] else {
            return nil
        }
        
        return ["apikey": publicKey]
    }
}
