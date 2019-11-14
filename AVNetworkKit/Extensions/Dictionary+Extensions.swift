//
//  Dictionary+Extensions.swift
//  AVNetworkKit
//
//  Created by Atharva Vaidya on 11/14/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import Foundation

internal extension Dictionary where Key == String, Value == Any? {
    /// Encode a dictionary as url encoded string
    ///
    /// - Parameter base: base url
    /// - Returns: encoded string
    /// - Throws: throw `.dataIsNotEncodable` if data cannot be encoded
    func urlEncodedString(base: String = "") throws -> String {
        guard count > 0 else { return "" } // nothing to encode
        let items: [URLQueryItem] = compactMap { key, value in
            guard let v = value else { return nil } // skip item if no value is set
            return URLQueryItem(name: key, value: String(describing: v))
        }
        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
            throw NetworkError.dataIsNotEncodable(self)
        }
        return encodedString.absoluteString
    }
}
