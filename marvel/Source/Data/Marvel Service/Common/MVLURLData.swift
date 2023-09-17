//
//  URLData.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

struct MVLURLData: MVLData {
    
    /// A text identifier for the URL.
    var type: `Type`
        
    /// A full URL (including scheme, domain, and path).
    var url: String
    
    enum `Type`: String, DefaultDecodable {
        case detail, wiki, comicLink, unspecified
        
        static var defaultValue: Self {
            return .unspecified
        }
    }
}
