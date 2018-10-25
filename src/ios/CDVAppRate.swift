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
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        return path.contains("CoreSimulator") || path.contains("sandboxReceipt")
    }
}
