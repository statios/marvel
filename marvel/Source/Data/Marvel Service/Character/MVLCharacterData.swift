//
//  CharacterData.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

struct MVLCharacterData: MVLData, MVLSummaryRepresentable {
    
    ///The unique ID of the character resource.
    var id: Int
    
    ///The name of the character.
    var name: String
    
    ///A short bio or description of the character.
    var description: String?
    
    /*
     "modified" : "-0001-11-30T00:00:00-0500"
     실제 값이 위와 같이 와서 디코딩 에러 발생하는 경우 있으므로 주석처리
     */
    ///The date the resource was most recently modified.
//    var modified: Date?
    
    ///The canonical URL identifier for this resource.
    var resourceURI: String
    
    ///A set of public web site URLs for the resource.
    var urls: [MVLURLData]?
    
    ///The representative image for this character.
    var thumbnail: MVLImageData?
    
    ///A resource list containing comics which feature this character.
    var comics: MVLResourceListData?
    
    ///A resource list of stories in which this character appears.
    var stories: MVLResourceListData?
    
    ///A resource list of events in which this character appears.
    var events: MVLResourceListData?
    
    ///A resource list of series in which this character appears.
    var series: MVLResourceListData?
    
}

struct MVLCharacterListRequest: Encodable, DictionaryConvertible {
    
    /// Return only characters matching the specified full character name (e.g. Spider-Man).
    var name: String?
    
    /// Return characters with names that begin with the specified string (e.g. Sp).
    var nameStartsWith: String?
    
    /// Return only characters which have been modified since the specified date.
    var modifiedSince: Date?
    
    /// Return only characters which appear in the specified comics (accepts a comma-separated list of ids).
    var comics: Int?
    
    /// Return only characters which appear the specified series (accepts a comma-separated list of ids).
    var series: Int?
    
    /// Return only characters which appear in the specified events (accepts a comma-separated list of ids).
    var events: Int?
    
    /// Return only characters which appear the specified stories (accepts a comma-separated list of ids).
    var stories: Int?
    
    /// Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
    var orderBy: OrderBy?
    
    var limit: Int?
    
    var offset: Int?
    
    enum OrderBy: String, Encodable {
        case name
        case modified
        case descendingName = "-name"
        case descendingModified = "-modified"
    }
}

struct MVLCharacterRequest: Encodable {
    
    /// A single character id.
    var characterId: Int
}
