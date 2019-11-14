//
//  Parser.swift
//  Movies
//
//  Created by Atharva Vaidya on 14/07/18.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

/// Generic Parser for a given type.
public class Parser<T> {
    public func parse(data: Data) throws -> T {
        throw NetworkError.failedToParseJSONData(data)
    }
}
