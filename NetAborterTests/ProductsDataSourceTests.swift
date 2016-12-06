//
//  ProductsDataSourceTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class ProductsDataSourceTests: XCTestCase {

    // MARK: Properties

    var managedObjectContext: NSManagedObjectContext!
    var user: User!
    var dataSource: ProductsDataSource!

    // MARK: Overrides

    override func setUp() {
        managedObjectContext = try! NSManagedObjectContext(storeType: .inMemory)
        user = User(managedObjectContext: self.managedObjectContext)
        dataSource = ProductsDataSource(user: self.user)
    }

    override func tearDown() {
        managedObjectContext.reset()
        managedObjectContext = nil
        user = nil
        dataSource = nil
    }

    // MARK: Tests


    func testNumberOfItemsInSectionMatchesTheNumberOfProducts() {

        let testCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        _ = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        _ = Product.newTestProductInContext(managedObjectContext: managedObjectContext)

        try! dataSource.fetchedResultsController.performFetch()

        XCTAssertEqual(dataSource.collectionView(testCollectionView, numberOfItemsInSection: 0), 2)
    }

}
