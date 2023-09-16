//
//  TextObjectData.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

struct MVLTextObjectData {
    
    /// The string description of the text object (e.g. solicit text, preview text, etc.).
    var type: String
    
    /// A language code denoting which language the text object is written in.
    var language: String
    
    /// The text of the text object.
    var text: String
}
