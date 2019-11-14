//
//  RequestSigner.swift
//  AVNetworkKit
//
//  Created by Atharva Vaidya on 11/14/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

import Foundation

protocol RequestSigner {
    func sign<T>(operation: NetworkOperation<T>) -> NetworkOperation<T>
}
