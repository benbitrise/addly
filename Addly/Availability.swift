//
//  Availability.swift
//  Addly
//
//  Created by Ben Boral on 12/6/23.
//

import Foundation

struct Availability {

    func doThing() -> Bool {
        if #available(iOS 16, *) {
            return true
        } else {
            return false
        }
    }
}
