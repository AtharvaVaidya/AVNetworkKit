//
//  NetworkError.swift
//  Movies
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

/// Possible networking error
///
/// - dataIsNotEncodable: data cannot be encoded in format you have specified
/// - stringFailedToDecode: failed to decode data with given encoding
public enum NetworkError: Error {
    case dataIsNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case invalidRequest(_: RequestProtocol)
    case error(_: ResponseProtocol)
    case noResponse(_: ResponseProtocol)
    case missingEndpoint
    case failedToParseJSON(_: NSDictionary, _: ResponseProtocol)
    case failedToParseJSONDictionary(_: [String: Any?])
    case failedToParseJSONData(_: Data)
    case failedToParseImageData(_: Data)
}
