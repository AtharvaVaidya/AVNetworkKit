//
//  APIResponse.swift
//  AVNetworkKit
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

public struct Response: ResponseProtocol {
    public let httpResponse: HTTPURLResponse?
    public let data: Data?
    let error: NSError?

    /// Type of result
    public let type: Response.NetworkResponseResult

    /// Status code of the response
    public var httpStatusCode: Int? {
        type.code
    }

    /// Request executed
    public let request: RequestProtocol

    /// Type of response
    ///
    /// - success: success
    /// - error: error
    public enum NetworkResponseResult {
        case success(_: Int)
        case error(_: Int)
        case noResponse

        private static let successCodes: Range<Int> = 200 ..< 299

        public static func from(response: URLResponse?) -> NetworkResponseResult {
            guard let r = response as? HTTPURLResponse
            else {
                return .noResponse
            }
            return (NetworkResponseResult.successCodes.contains(r.statusCode) ? .success(r.statusCode) : .error(r.statusCode))
        }

        public var code: Int? {
            switch self {
            case let .success(code): return code
            case let .error(code): return code
            case .noResponse: return nil
            }
        }
    }

    init(response: URLResponse?, data: Data?, error: NSError?, request: RequestProtocol) {
        httpResponse = response as? HTTPURLResponse
        self.data = data
        self.error = error
        type = NetworkResponseResult.from(response: response)
        self.request = request
    }

    public func toJSON() -> NSDictionary {
        NSDictionary()
    }

    public func toString(_: String.Encoding?) -> String? {
        nil
    }
}
