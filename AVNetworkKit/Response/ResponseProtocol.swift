//
//  ResponseProtocol.swift
//  AVNetworkKit
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

public protocol ResponseProtocol {
    /// Type of response (success or failure)
    var type: Response.NetworkResponseResult { get }

    /// Request
    var request: RequestProtocol { get }

    /// Return the http url response
    var httpResponse: HTTPURLResponse? { get }

    /// Return HTTP status code of the response
    var httpStatusCode: Int? { get }

    /// Return the raw Data instance response of the request
    var data: Data? { get }

    /// Attempt to decode Data received from server and return a JSON object.
    /// If it fails it will return an empty JSON object.
    /// Value is stored internally so subsequent calls return cached value.
    ///
    /// - Returns: JSON
    func toJSON() -> NSDictionary

    /// Attempt to decode Data received from server and return a String object.
    /// If it fails it return `nil`.
    /// Call is not cached but evaluated at each call.
    /// If no encoding is specified, `utf8` is used instead.
    ///
    /// - Parameter encoding: encoding of the data
    /// - Returns: String or `nil` if failed
    func toString(_ encoding: String.Encoding?) -> String?
}
