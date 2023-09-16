//
//  ResourceListData.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

struct MVLResourceListData {
    
    /// The number of total available resources in this list
    var available: Int
    
    /// The number of resources returned in this resource list (up to 20).
    var returned: Int
    
    /// The path to the list of full view representations of the items in this resource list.
    var collectionURI: String
    
    /// A list of summary views of the items in this resource list.
    var items: [MVLSummaryDataRepresentable]
    
}
