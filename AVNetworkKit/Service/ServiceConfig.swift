//  ServiceConfig.swift
//  Movies
//
//  Created by Atharva Vaidya on 13/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

/// This class is used to configure network connection with a backend server
public final class ServiceConfig {
    /// Name of the server configuration. Typically you can add it your environment name, ie. "Testing" or "Production"
    private(set) var name: String

    /// This is the base host url (ie. "http://www.myserver.com/api/v2"
    private(set) var url: URL

    /// These are the global headers which must be included in each session of the service
    private(set) var headers: HeadersDict = [:]

    /// Cache policy you want apply to each request done with this service
    /// By default is `.useProtocolCachePolicy`.
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    /// Global timeout for any request. If you want, you can override it in Request
    /// Default value is 15 seconds.
    public var timeout: TimeInterval = 15.0

    /// Initialize a new service configuration
    ///
    /// - Parameters:
    ///   - name: name of the configuration (its just for debug purpose)
    ///   - urlString: base url of the service
    ///   - api: path to APIs service endpoint
    public init?(name: String? = nil, base urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
        self.name = name ?? (url.host ?? "")
    }

    public init(name: String? = nil, base url: URL) {
        self.url = url
        self.name = name ?? (url.host ?? "")
    }
    
}

extension ServiceConfig: CustomStringConvertible {
    /// Readable description
    public var description: String {
        "\(name): \(url.absoluteString)"
    }
}

extension ServiceConfig: Equatable {
    /// A Service configuration is equal to another if both url and path to APIs endpoint are the same.
    /// This comparison ignore service name.
    ///
    /// - Parameters:
    ///   - lhs: configuration a
    ///   - rhs: configuration b
    /// - Returns: `true` if equals, `false` otherwise
    public static func == (lhs: ServiceConfig, rhs: ServiceConfig) -> Bool {
        lhs.url.absoluteString.lowercased() == rhs.url.absoluteString.lowercased()
    }
}

extension ServiceConfig {
    enum AuthorizationType {
        case bearerToken
    }
}
