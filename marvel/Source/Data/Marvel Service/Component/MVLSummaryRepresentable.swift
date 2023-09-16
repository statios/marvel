//
//  SummaryDataRepresentable.swift
//  marvel
//
//  Created by stat on 2023/09/16.
//

import Foundation

protocol MVLSummaryRepresentable: Decodable {
    var name: String { get }
    var resourceURI: String { get }
}

/// A type-erased MVLSummaryRepresentable value
struct AnyMVLSummaryRepresentable: MVLSummaryRepresentable {
    var name: String
    var resourceURI: String
}
