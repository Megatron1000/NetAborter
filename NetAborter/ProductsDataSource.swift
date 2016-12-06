//
//  ProductsDataSource.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import UIKit
import CoreData

class ProductsDataSource: NSObject {

    // MARK: Results enum

    enum ProductsDataSourceResult {
        case success
        case failure(error: Error)
    }

    // MARK: Properties

    let user: User
    let managedObjectContext: NSManagedObjectContext

    lazy private(set) var fetchedResultsController: NSFetchedResultsController<Product> = {

        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Product.name), ascending: true)]

        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: self.managedObjectContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: "Products")
    }()

    lazy fileprivate var productsService: ProductsService = {
        return ProductsService(httpClient: HTTPClient(), managedObjectContext: self.managedObjectContext)
    }()

    // MARK: Initialisation

    required init(user: User) {
        self.user = user

        guard let managedObjectContext = user.managedObjectContext else {
            fatalError("Initialised with a user without a managed object context")
        }

        self.managedObjectContext = managedObjectContext
    }

    // MARK: Data Reloading

    func reloadData(with completion: @escaping ((ProductsDataSourceResult) -> Void)) {

        productsService.retrieveProducts { [weak self] result in

            switch result {

            case .success(_):
                do {
                    NSFetchedResultsController<Product>.deleteCache(withName: self?.fetchedResultsController.cacheName)
                    try self?.fetchedResultsController.performFetch()
                    completion(ProductsDataSourceResult.success)
                } catch {
                    completion(ProductsDataSourceResult.failure(error: error))
                }

            case .failure(let error):
                completion(ProductsDataSourceResult.failure(error: error))

            }
        }
    }

    // MARK: Favouriting

    func toggleIsFavourited(at indexPath: IndexPath) {
        let product = fetchedResultsController.object(at: indexPath)
        user.toggleIsProductFavourited(product)
        try? managedObjectContext.save()
    }
}

// MARK: UICollectionViewDataSource

extension ProductsDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }

        return sectionInfo.numberOfObjects
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let product = fetchedResultsController.object(at: indexPath)

        guard
            let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else {
                fatalError("Wrong cell deqeued for identifier \(ProductCollectionViewCell.reuseIdentifier)")
        }

        productCell.nameLabel?.text = product.name
        productCell.priceLabel?.text = product.localizedPriceString
        productCell.favouritedImageView?.isHidden = !user.isProductFavourited(product)

        // If we already have saved an image, reuse that. Otherwise fetch a new one and save it
        if let image = product.image {
            productCell.imageView?.image = image
        } else {
            productsService.retrieveImage(for: product, completion: { result in
                switch result {
                case .success(let productImage):
                    guard collectionView.indexPath(for: productCell) == indexPath else {
                        return // the cell was reused before we downloaded the image
                    }
                    productCell.imageView?.image = productImage.image

                default:
                    break
                }
            })
        }

        return productCell
    }

}
