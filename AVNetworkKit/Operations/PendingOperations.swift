//
//  PendingOperations.swift
//  Movies
//
//  Created by Atharva Vaidya on 16/08/2018.
//  Copyright © 2018 Atharva vaidya. All rights reserved.
//

import Foundation

class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
