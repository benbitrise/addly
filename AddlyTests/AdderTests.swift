//
//  AdderTests.swift
//  AddlyTests
//
//  Created by Ben Boral on 8/31/22.
//

import XCTest
@testable import Addly

class AdderTests: XCTestCase {

    func testAdder_happyPath() {
        executeAddingTest(operand1: "1", operand2: "3", expected: .added("3"))
    }

    func testAdder_onlyOneArg() {
        executeAddingTest(operand1: "1", operand2: nil, expected: .nothingToAdd)
    }

    func testAdder_badValues() {
        executeAddingTest(operand1: "not a number", operand2: "another not a number", expected: .nothingToAdd)
    }

    private func executeAddingTest(operand1: String, operand2: String?, expected: AddingStatus) {
        let expectation = XCTestExpectation(description: "Add asynchronously")
        let adder = Adder(intervalMaker: ZeroIntervalMaker())
        let operandNum1 = NumbersOnly()
        operandNum1.value = operand1
        let operandNum2 = NumbersOnly()
        if let operand2Val = operand2 {
            operandNum2.value = operand2Val
        }

        adder.add(operand1: operandNum1, operand2: operandNum2) { addingStatus in
            XCTAssertEqual(addingStatus, expected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

}
