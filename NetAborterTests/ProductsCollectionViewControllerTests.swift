//
//  ProductsCollectionViewControllerTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class ProductsCollectionViewControllerTests: XCTestCase {

    // MARK: Properties

    var managedObjectContext: NSManagedObjectContext!
    var user: User!
    var productsCollectionViewController: ProductsCollectionViewController!

    // MARK: Overrides

    override func setUp() {
        managedObjectContext = try! NSManagedObjectContext(storeType: .inMemory)
        user = User(managedObjectContext: self.managedObjectContext)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController()
        productsCollectionViewController = rootViewController?.childViewControllers.first as! ProductsCollectionViewController
        productsCollectionViewController.user = self.user
    }

    override func tearDown() {
        productsCollectionViewController = nil
        managedObjectContext.reset()
        managedObjectContext = nil
    }

    // MARK: Tests

    func testMainStoryboardInitialisesProductsCollectionViewControllerAsFirstChildViewController() {
        XCTAssertNotNil(productsCollectionViewController)
    }

    func testCollectionViewDisplaysAllItemsInSection() {

        _ = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        _ = Product.newTestProductInContext(managedObjectContext: managedObjectContext)

        try! productsCollectionViewController?.dataSource.fetchedResultsController.performFetch()
        productsCollectionViewController?.collectionView?.reloadData()

        XCTAssertEqual(productsCollectionViewController?.collectionView?.numberOfItems(inSection: 0), 2)
    }

    func testCollectionViewHasExactlyOneSection() {
        XCTAssertEqual(productsCollectionViewController?.collectionView?.numberOfSections, 1)
    }

    func testCellAtIndexPathIsConfigured() {

        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        _ = productsCollectionViewController.view

        try! productsCollectionViewController?.dataSource.fetchedResultsController.performFetch()
        productsCollectionViewController?.collectionView?.reloadData()

        let firstIndexPath = IndexPath(item: 0, section: 0)
        let collectionView = productsCollectionViewController.collectionView!
        let dataSource = productsCollectionViewController!.dataSource

        let cell = dataSource.collectionView(collectionView, cellForItemAt: firstIndexPath) as? ProductCollectionViewCell
        XCTAssertEqual(cell?.nameLabel?.text, "Test Name")
        XCTAssertEqual(cell?.priceLabel?.text, "£100.00")
        XCTAssertEqual(UIImagePNGRepresentation((cell?.imageView!.image!)!), UIImagePNGRepresentation(product.image!))
    }

}
