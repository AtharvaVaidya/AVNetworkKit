//
//  Service.swift
//  AVNetworkKit
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

    public func execute(request: RequestProtocol, completionHandler: @escaping (Result<Data, NetworkError>) -> ()) {
        do {
            let urlRequest = try request.urlRequest(in: self)
            
            let completionHandlerForDataTask = { (data: Data?, response: URLResponse?, error: Error?) in

                let parsedResponse = Response(response: response, data: data, error: error as NSError?, request: request)

                switch parsedResponse.type {
                case .success: // success
                    guard let data = data else {
                        completionHandler(.failure(.error(parsedResponse)))
                        return
                    }
                    completionHandler(.success(data))
                case .error: // failure
                    completionHandler(.failure(.error(parsedResponse)))
                case .noResponse: // no response
                    completionHandler(.failure(.noResponse(parsedResponse)))
                }
            }
            
            let urlSession: URLSession
            
            if let context = request.context {
                urlSession = URLSession(configuration: URLSession.shared.configuration, delegate: URLSession.shared.delegate, delegateQueue: context)
            } else {
                urlSession = URLSession.shared
            }

            let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: completionHandlerForDataTask)

            dataTask.resume()
        } catch {
            completionHandler(.failure(.invalidRequest(request)))
        }
    }
}
