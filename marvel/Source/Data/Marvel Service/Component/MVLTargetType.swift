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
import CryptoKit
import Moya

protocol MVLTargetType: TargetType {
    
}

extension MVLTargetType {
    
    var baseURL: URL {
        var url = URL(string: "https://gateway.marvel.com/")!
        if let plistPath = Bundle.main.path(forResource: "SecretInfo", ofType: "plist"),
           let rawData = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
           let realData = try? PropertyListSerialization.propertyList(from: rawData, format: nil) as? [String: Any],
           let marvelInfo = realData["Marvel Comics API Information"] as? [String: Any],
           let publicKey = marvelInfo["Public Key"] as? String,
           let privateKey = marvelInfo["Private Key"] as? String {
            let timestamp = String(Date().timeIntervalSince1970)
            url.append(queryItems: [
                URLQueryItem(name: "apikey", value: publicKey),
                URLQueryItem(name: "ts", value: timestamp),
                URLQueryItem(name: "hash", value: "\(timestamp)\(privateKey)\(publicKey)".md5)
            ])
        }
        return url
    }
    
    var headers: [String : String]? {
        return nil
    }
}

extension String {

    var md5: String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
