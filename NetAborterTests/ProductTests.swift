//
//  ProductTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class ProductTests: XCTestCase {

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

        let testProductDictionary: [String : Any] = [
            "name":"A Jumper",
            "id": 123,
            "price": testPriceDictionary
            ]

        let product = Product(context: managedObjectContext, dictionary: testProductDictionary)

        XCTAssertNotNil(product)
        XCTAssertEqual(product?.id, "123")
        XCTAssertEqual(product?.name, "A Jumper")
        XCTAssertNotNil(product?.price)
    }

    func testInitReturnsNilWithInvalidDictionary() {

        let testProductDictionary: [String : Any] = [
            "name":"A Jumper"
        ]

        let product = Product(context: managedObjectContext, dictionary: testProductDictionary)

        XCTAssertNil(product, "Initialising a product with a dictionary that's missing required fields should fail")
    }

    func testLocalisedPriceString() {

        let price = Price(managedObjectContext: managedObjectContext)
        price.amount = NSDecimalNumber(value: 123.45)
        price.currency = "GBP"

        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        product.price = price

        XCTAssertEqual(product.localizedPriceString, "£123.45")
    }

}
