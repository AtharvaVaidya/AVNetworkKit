//
//  Request.swift
//  Movies
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

public class Request: RequestProtocol {
    public var page: Int?

    public var context: Context?

    /// Endpoint for request
    public var endpoint: String

    /// Body of the request
    public var body: RequestBody?

    /// HTTP method of the request
    public var method: HTTPMethod?

    /// Fields of the request
    public var fields: ParamsDict?

    /// URL of the request
    public var urlParams: ParamsDict?

    /// Headers of the request
    public var headers: HeadersDict?

    /// Cache policy
    public var cachePolicy: URLRequest.CachePolicy?

    /// Timeout of the request
    public var timeout: TimeInterval?

    /// Initialize a new request
    ///
    /// - Parameters:
    ///   - method: HTTP Method request (if not specified, `.get` is used)
    ///   - endpoint: endpoint of the request
    ///   - params: paramters to replace in endpoint
    ///   - fields: fields to append inside the url
    ///   - body: body to set
    public init(method: HTTPMethod = .get, endpoint: String = "", params: ParamsDict? = nil, fields: ParamsDict? = nil, body: RequestBody? = nil, page: Int? = nil) {
        self.method = method
        self.endpoint = endpoint
        urlParams = params
        self.fields = fields
        self.body = body
        self.page = page
    }
}
