//
//  String+Extensions.swift
//  AVNetworkKit
//
//  Created by Atharva Vaidya on 11/14/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import Foundation

internal extension String {
    /// Fill up a string by replacing values in specified placeholders
    ///
    /// - Parameter dict: dict to use
    /// - Returns: replaced string
    func fill(withValues dict: [String: Any?]?) -> String {
        guard let data = dict else {
            return self
        }
        var finalString = self
        data.forEach { arg in
            if let unwrappedValue = arg.value {
                finalString = finalString.replacingOccurrences(of: "{\(arg.key)}", with: String(describing: unwrappedValue))
            }
        }
        return finalString
    }

    func stringByAdding(urlEncodedFields fields: ParamsDict?) throws -> String {
        guard let f = fields else { return self }
        return try f.urlEncodedString(base: self)
    }
}
