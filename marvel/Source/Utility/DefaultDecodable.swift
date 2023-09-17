//
//  DefaultDecodable.swift
//  marvel
//
//  Created by stat on 2023/09/17.
//

import Foundation

/*
 `DefaultDecodable` protocol extends `Decodable`.
 This protocol requires a static `defaultValue` property which will be used when decoding fails.
 This can be particularly useful in scenarios where the enum cases can change after client release.
 In such cases, if the server sends a case that the current client version is not aware of,
 the decoding will fail and `defaultValue` will be used instead,
 thus gracefully handling unknown cases and preventing crashes.
*/
protocol DefaultDecodable: Decodable, RawRepresentable {
    static var defaultValue: Self { get }
}

/*
 Provide a default implementation for `DefaultDecodable` when `Self` is `RawRepresentable`
 and the `RawValue` of `Self` is `Decodable`.
 This is particularly useful for enums with raw values.
 When the decoding of the raw value fails, it falls back to `defaultValue`.
 This helps in maintaining backward compatibility when new cases are added to the enum after client release.
*/
extension DefaultDecodable where RawValue: Decodable {
    
    init(from decoder: Decoder) throws {
        // Decode the raw value from the decoder.
        let container = try decoder.singleValueContainer()
        
        let rawValue = try container.decode(RawValue.self)

        /*
         Try to create an instance of `Self` using the decoded raw value.
         If this fails (because the raw value does not correspond to a valid instance), use `defaultValue`.
         This way, if the enum changes on the server-side and the client is not updated,
         the app won't crash when trying to decode an unknown case. Instead, it will use the `defaultValue`.
        */
        self = Self(rawValue: rawValue) ?? .defaultValue
    }
}
