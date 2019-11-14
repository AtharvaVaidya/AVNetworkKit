//
//  Service.swift
//  Movies
//
//  Created by Atharva Vaidya on 13/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

/// Service is a concrete implementation of the ServiceProtocol
public class Service: ServiceProtocol {
    /// Configuration
    public var configuration: ServiceConfig

    /// Session headers
    public var headers: HeadersDict

    /// Initialize a new service with given configuration
    ///
    /// - Parameter configuration: configuration. If `nil` is passed attempt to load configuration from your app's Info.plist
    public required init(_ configuration: ServiceConfig) {
        self.configuration = configuration
        headers = self.configuration.headers // fillup with initial headers
    }

    public init(serviceConfig: ServiceConfig) {
        self.configuration = serviceConfig
        self.headers = serviceConfig.headers
    }

    public func execute(request: RequestProtocol, _ success: @escaping (Data) -> Void, _ failure: @escaping (NetworkError) -> Void) {
        do {
            let urlRequest = try request.urlRequest(in: self)
            
            let completionHandler = { (data: Data?, response: URLResponse?, error: Error?) in

                let parsedResponse = Response(response: response, data: data, error: error as NSError?, request: request)

                switch parsedResponse.type {
                case .success: // success
                    guard let data = data else {
                        failure(NetworkError.error(parsedResponse))
                        return
                    }
                    success(data)
                case .error: // failure
                    failure(NetworkError.error(parsedResponse))
                case .noResponse: // no response
                    failure(NetworkError.noResponse(parsedResponse))
                }
            }
            
            let urlSession: URLSession
            
            if let context = request.context {
                urlSession = URLSession(configuration: URLSession.shared.configuration, delegate: URLSession.shared.delegate, delegateQueue: context)
            } else {
                urlSession = URLSession.shared
            }

            let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)

            dataTask.resume()
        } catch {
            failure(NetworkError.invalidRequest(request))
        }
    }
}
