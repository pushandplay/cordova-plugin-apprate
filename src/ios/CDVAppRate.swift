//
//  CDVAppRate.swift
//  Pulse Community
//
//  Created by Pulse LTD, LLC on 10/25/18.
//

import Foundation

class SwiftAppRate: NSObject {
//    class func `new`() -> SwiftAppRate {
//        return SwiftAppRate()
//    }
    @objc
    func isTestFlight() -> Bool {
        return (Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil);
    }
}
