//
//  ServiceProtocol.swift
//  Movies
//
//  Created by Atharva Vaidya on 13/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    /// This is the configuration used by the service
    var configuration: ServiceConfig { get }

    /// Headers used by the service. These headers are mirrored automatically
    /// to any Request made using the service. You can replace or remove it
    /// by overriding the `willPerform()` func of the `Request`.
    /// Session headers initially also contains global headers set by related server configuration.
    var headers: HeadersDict { get }

    /// Initialize a new service with specified configuration
    ///
    /// - Parameter configuration: configuration to use
    init(_ configuration: ServiceConfig)

    func execute(request: RequestProtocol, completionHandler: @escaping (Result<Data, NetworkError>) -> ())
}
