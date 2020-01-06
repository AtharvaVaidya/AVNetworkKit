//
//  AVNetworkKitTests.swift
//  AVNetworkKitTests
//
//  Created by Atharva Vaidya on 11/14/19.
//  Copyright © 2019 Atharva Vaidya. All rights reserved.
//

@testable import AVNetworkKit
import XCTest

class AVNetworkKitTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let urlString = "https://api.appstoreconnect.apple.com/v1/apps"
        guard let url = URL(string: urlString) else {
            return
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
