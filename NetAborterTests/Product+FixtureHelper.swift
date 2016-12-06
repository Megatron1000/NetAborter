//
//  Product+FixtureHelper.swift
//  NetAborter
//
//  Created by Mark Bridges on 28/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import CoreData
@testable import NetAborter

extension Product {

    /// Returns a fully instantiated product, along with it's relationships and some test information
    class func newTestProductInContext(managedObjectContext: NSManagedObjectContext) -> Product {

        let bundle = Bundle(for: ProductServiceTests.self)
        let imageFixtureUrl = bundle.url(forResource: "productImage", withExtension: "jpg")!
        let imageFixtureData = try! Data(contentsOf: imageFixtureUrl)

        let product = Product(managedObjectContext: managedObjectContext)
        product.id = UUID().uuidString
        product.name = "Test Name"

        let productImage = ProductImage(managedObjectContext: managedObjectContext)
        productImage.imageData = imageFixtureData as NSData
        productImage.product = product

        let price = Price(managedObjectContext: managedObjectContext)
        price.amount = NSDecimalNumber(value: 100)
        price.currency = "GBP"
        price.product = product
        
        return product
    }
}
