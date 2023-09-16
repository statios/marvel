//
//  MVLResultData.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

struct MVLResult<T: MVLData>: Decodable {
    
    /// The HTTP status code of the returned result
    var code: Int
    
    /// A string description of the call status
    var status: String
    
    /// The results returned by the call
    var data: MVLDataContainer<T>
    
    /// The copyright notice for the returned result
    var copyright: String
    
    /// The attribution notice for this result
    var attributionText: String
    
    /// An HTML representation of the attribution notice for this result
    var attributionHTML: String
    
}

struct MVLDataContainer<T: MVLData>: Decodable {
    
    /// The requested offset (skipped results) of the call
    var offset: Int
    
    /// The requested result limit
    var limit: Int
    
    /// The total number of results available
    var total: Int
    
    /// The total number of results returned by this call
    var count: Int
    
    /// The list of entities returned by the call
    var results: [T]
}

struct MVLError: Decodable {
    
    /*
     409    Limit greater than 100.
     409    Limit invalid or below 1.
     409    Invalid or unrecognized parameter.
     409    Empty parameter.
     409    Invalid or unrecognized ordering parameter.
     409    Too many values sent to a multi-value list filter.
     409    Invalid value passed to filter.
     */
    
    /// the http status code of the error
    var code: Int
    
    /// a description of the error
    var status: String
}
