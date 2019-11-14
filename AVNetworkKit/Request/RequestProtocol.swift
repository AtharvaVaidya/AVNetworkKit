//
//  RequestProtocol.swift
//  Movies
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

/// This is the base class for a Request
public protocol RequestProtocol {
    typealias Context = OperationQueue

    /// The context in which the request is executed.
    /// You may, for example, choose a custom queue in which execute the request.
    /// If `nil` is returned default's `.background` queue is used instead.
    var context: Context? { get set }

    /// This is the endpoint of the request (ie. `/v2/auth/login`)
    var endpoint: String { get set }
    
    ///The page to be request if pagination is supported.
    var page: Int? { get set }

    /// The HTTP method used to perform the request.
    var method: HTTPMethod? { get set }

    /// Parameters used to compose the fields dictionary into the url.
    /// They will be automatically converted inside the url.
    /// `null` value wil be ignored automatically; all values must be also represented as `String`,
    /// otherwise will be ignored.
    /// For example `{ "p1" : "abc", "p2" : null, "p3" : 3 }` will be `.../endpoint?p1=abc&p3=3`
    var fields: ParamsDict? { get set }

    /// Parameters used to compose the endpoint url.
    /// Value is a dictionary with keys to replace; `null` values are ignored.
    /// Example: `/v2/articles/{table_id}/{article_id}/` will be composed by replacing `{table_id}` and `{article_id]`
    /// with the values passed here.
    var urlParams: ParamsDict? { get set }

    /// THe body of the request. Will be encoded based upon the
    var body: RequestBody? { get set }

    /// Optional headers to append to the request.
    var headers: HeadersDict? { get set }

    /// This is the default cache policy used for this request.
    /// If not set related `Service` policy is used.
    var cachePolicy: URLRequest.CachePolicy? { get set }

    /// This is the time interval of the request.
    /// If not set related `Service` timeout is used.
    var timeout: TimeInterval? { get set }

    /// This function combine the specific request headers with the service's list
    /// and produce the headers to send along the request.
    /// You may not need to override this function; default implementation is already provided.
    /// Note: Default implementation prioritizie request's specific headers, so in case of duplicate
    /// header's key request's value win over the service's value.
    ///
    /// - Parameter service: service in which the request should be used
    /// - Returns: ParametersDict
    func headers(in service: ServiceProtocol) -> HeadersDict

    /// Return the full url of the request when executed in a specific service
    ///
    /// - Parameter service: service
    /// - Returns: URL
    func url(in service: ServiceProtocol) throws -> URL

    /// Create an URLRequest from a Request into the current service.
    ///
    /// - Parameter request: request
    /// - Returns: URLRequest
    /// - Throws: throw an exception if something goes wrong while making data
    func urlRequest(in service: ServiceProtocol) throws -> URLRequest
}

// MARK: - Provide default implementation of the Request

public extension RequestProtocol {
    func headers(in service: ServiceProtocol) -> HeadersDict {
        var params: HeadersDict = service.headers // initial set is composed by service's current headers
        // append (and replace if needed) with request's headers
        headers?.forEach { k, v in params[k] = v }
        return params
    }

    func url(in service: ServiceProtocol) throws -> URL {
        // Compose request URL by taking configuration's full url (service url + request endpoint)
        let baseURL = service.configuration.url.absoluteString.appending(endpoint).appending(page == nil ? "" : "&page=\(page!)")

        // Append request's endpoint and eventually:
        //  - replace `urlParams` if specified
        //  - append fields url as encoded url
        let fullURLString = try baseURL.fill(withValues: urlParams).stringByAdding(urlEncodedFields: fields)
        guard let url = URL(string: fullURLString)
        else {
            throw NetworkError.invalidURL(fullURLString)
        }
        return url
    }

    func urlRequest(in service: ServiceProtocol) throws -> URLRequest {
        // Compose default full url
        let requestURL = try url(in: service)

        // Setup cache policy, timeout and headers of the request
        let cachePolicy = self.cachePolicy ?? service.configuration.cachePolicy
        let timeout = self.timeout ?? service.configuration.timeout
        let headers = self.headers(in: service)

        // Create the URLRequest object
        var urlRequest = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = (method ?? .get).rawValue // if not specified default HTTP method is GET
        urlRequest.allHTTPHeaderFields = headers
        if let bodyData = try self.body?.encodedData() { // set body if specified
            urlRequest.httpBody = bodyData
        }
        
        return urlRequest
    }
}
