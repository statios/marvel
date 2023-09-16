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
    
    ///The date the resource was most recently modified.
    var modified: Date?
    
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
