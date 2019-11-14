//
//  Operation.swift
//  Movies
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import UIKit

/// Generic Operation object that outlines that basics of an operation
public class NetworkOperation<T>: Operation {
    var request: RequestProtocol
    let service: Service

    var completionHandler: ((Result<T, NetworkError>) -> ())

    public init(request: RequestProtocol, serviceConfig: ServiceConfig, completionHandler: @escaping (Result<T, NetworkError>) -> ()) {
        self.request = request
        self.service = Service(serviceConfig)
        self.completionHandler = completionHandler
    }

    public override func main() {
        if isCancelled { return }

        execute()
    }

    /// Executes the operation and tried to parse the data received from the service. If it is not able to parse the data then we return a `NetworkError.failedToParseJSONData`.
    func execute() {
        service.execute(request: request) { (result) in
            switch result {
            case .failure(let networkError):
                self.completionHandler(.failure(networkError))
            case .success(let data):
                do {
                    let parsedObject = try self.parser().parse(data: data)
                    self.completionHandler(.success(parsedObject))
                } catch {
                    self.completionHandler(.failure(.failedToParseJSONData(data)))
                }
            }
        }
    }

    /// The Parser for the current operation
    ///
    /// - Returns: A parser for the type of the current operation.
    public func parser() -> Parser<T> {
        Parser<T>()
    }
}
