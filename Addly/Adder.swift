//
//  Adder.swift
//  Addly
//
//  Created by Ben Boral on 8/30/22.
//

import Foundation

enum AddingStatus: Equatable {
    case nothingToAdd
    case adding
    case added(String)
    case error
}


struct Adder {

    let intervalMaker: IntervalMaker

    func add(
        operand1: NumbersOnly,
        operand2: NumbersOnly,
        completion: @escaping ((AddingStatus) -> Void)) {
        guard let operand1 = Int(operand1.value), let operand2 = Int(operand2.value) else {
            completion(.nothingToAdd)
            return
        }
            let delay = intervalMaker.makeInterval()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.added(String(operand1 + operand2)))
        }
    }
}
