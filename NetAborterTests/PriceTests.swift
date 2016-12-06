//
//  PriceTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class PriceTests: XCTestCase {

    // MARK: Properties

    var managedObjectContext: NSManagedObjectContext!

    // MARK: Overrides

    override func setUp() {
        managedObjectContext = try! NSManagedObjectContext(storeType: .inMemory)
    }

    override func tearDown() {
        managedObjectContext.reset()
        managedObjectContext = nil
    }
    
    // MARK: Tests

    func testInitWithValidDictionary() {

        let testPriceDictionary: [String : Any] = [
            "currency": "GBP",
            "divisor": 100,
            "amount": 64000
        ]

        let price = Price(context: managedObjectContext, dictionary: testPriceDictionary)

        XCTAssertNotNil(price)
        XCTAssertEqual(price?.currency, "GBP")
        XCTAssertEqual(price?.amount, NSDecimalNumber(value: 640))
    }

    func testInitReturnsNilWithInvalidDictionary() {

        let testPriceDictionary: [String : Any] = [
            "currency": "GBP"
        ]

        let price = Price(context: managedObjectContext, dictionary: testPriceDictionary)

        XCTAssertNil(price, "Initialising a price with a dictionary that's missing required fields should fail")
    }

    func testLocalisedPriceString() {

        let price = Price(managedObjectContext: managedObjectContext)
        price.amount = NSDecimalNumber(value: 123.45)
        price.currency = "GBP"

        XCTAssertEqual(price.localizedString, "£123.45")
    }

}
