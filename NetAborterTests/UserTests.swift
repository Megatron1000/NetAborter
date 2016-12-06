//
//  UserTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 28/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class UserTests: XCTestCase {

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

    func testIsProductIsFavouritedTrue() {

        let user = User(managedObjectContext: managedObjectContext)

        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)

        user.addToFavouriteProducts(product)

        XCTAssertTrue(user.isProductFavourited(product))
    }

    func testIsProductIsFavouritedFalse() {

        let user = User(managedObjectContext: managedObjectContext)
        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)

        XCTAssertFalse(user.isProductFavourited(product))
    }

}
