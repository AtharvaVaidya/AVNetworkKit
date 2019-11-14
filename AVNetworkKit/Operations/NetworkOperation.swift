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

    init(request: RequestProtocol, serviceConfig: ServiceConfig, completionHandler: @escaping (Result<T, NetworkError>) -> ()) {
        self.request = request
        self.service = Service(serviceConfig)
        self.completionHandler = completionHandler
    }

    public override func main() {
        if isCancelled { return }

        execute()
    }

    /// Executes the operation
    ///
    /// - Parameters:
    ///   - success: Block with the type associated with the operation.
    ///   - failure: Block in case the operation fails. Provides a NetworkError object.
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
