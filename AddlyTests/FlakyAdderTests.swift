//
//  FlakyTests.swift
//  AddlyTests
//
//  Created by Ben Boral on 2/16/24.
//

import XCTest

// swiftlint:disable type_body_length
// swiftlint:disable file_length
final class FlakyAdderTests: XCTestCase {

    func testRand100Under2() {
        generateAndCheckRandomNumber(fromOneTo: 100)
    }

    func generateAndCheckRandomNumber(fromOneTo upperBound: Int) {
        let randomNumber = Int.random(in: 1...upperBound)
        XCTAssert(randomNumber > 2, "Random number \(randomNumber) is not above 2")
    }
}
// swiftlint:enable type_body_length
