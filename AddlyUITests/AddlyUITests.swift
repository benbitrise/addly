//
//  AddlyUITests.swift
//  AddlyUITests
//
//  Created by Ben Boral on 7/26/21.
//

import XCTest

class AddlyUITests: XCTestCase {

    func testAdding() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let operand1 = app.textFields["operand1"]
        let operand2 = app.textFields["operand2"]
        let result = app.staticTexts["result"]
        operand1.tap()
        operand1.typeText("11")
        operand2.tap()
        operand2.typeText("22")
        validateResultAsync(result: result, expectedValue: "33")
    }

    func testAddingOneOperand() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let operand1 = app.textFields["operand1"]
        let result = app.staticTexts["result"]
        operand1.tap()
        operand1.typeText("11")
        validateResultAsync(result: result, expectedValue: "0")
    }

    private func validateResultAsync(result: XCUIElement, expectedValue: String) {
        let predicate = NSPredicate { _, _ in result.label == expectedValue }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: nil)
        let expectationResult = XCTWaiter().wait(for: [expectation], timeout: 4)
        if expectationResult != .completed {
            XCTFail("Expected \(expectedValue) but got \(result.label)")
        }
    }
}
