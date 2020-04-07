//
//  ProductsService.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData

class ProductsService {

    // MARK: Error Enums

    enum ProductsServiceError: Error {
        case emptyResponse
        case undeserializableResponse
        case unexpectedResponse
    }

    // MARK: Result Enums

    enum RetreiveProductsResult {
        case success(products: [Product])
        case failure(error: Error)
    }

    enum RetreiveProductImageResult {
        case success(productImage: ProductImage)
        case failure(error: Error)
    }

    // MARK: Properties

    let httpClient: HTTPClient
    let managedObjectContext: NSManagedObjectContext

    // MARK: Initialisation

    required init(httpClient: HTTPClient, managedObjectContext: NSManagedObjectContext) {
        self.httpClient = httpClient
        self.managedObjectContext = managedObjectContext
    }

    // MARK: Network calls

    func retrieveProducts(with completion: @escaping ((RetreiveProductsResult) -> Void)) {

        // This call looks like it paginates, but as far as I can tell implementing pagination is outside the scope of this test
        guard let url = URL(string: "http://api.net-a-porter.com/NAP/GB/en/60/0/summaries?categoryIds=2") else {
            fatalError("Unable to form URL for request")
        }

        httpClient.makeNetworkRequest(with: url, completion: { [weak self] result in

            DispatchQueue.main.async(execute: {

                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let data):

                    // Normally would do something a bit more fine grained than this
                    guard
                        let data = data,
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let rootDictionary = jsonData as? [String:Any],
                        let productDictionaries = rootDictionary["summaries"] as? [[String:Any]] else {
                            completion(.failure(error: ProductsServiceError.unexpectedResponse))
                            return
                    }

                    let products: [Product] = productDictionaries.compactMap { productDictionary in
                        return Product(context: strongSelf.managedObjectContext, dictionary: productDictionary)
                    }

                    completion(.success(products: products))

                case .failure(let error):
                    completion(.failure(error: error))
                }

            })

        })
    }

    func retrieveImage(for product: Product, completion: @escaping ((RetreiveProductImageResult) -> Void)) {

        guard let imageId = product.id else {
            fatalError("Attempted to retrieve image for product without an id")
        }

        guard let url = URL(string: "http://cache.net-a-porter.com/images/products/\(imageId)/\(imageId)_fr_sl.jpg") else {
            fatalError("Unable to form URL for request")
        }

        httpClient.makeNetworkRequest(with: url, completion: { [weak self] result in

            DispatchQueue.main.async(execute: {

                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let data):

                    guard
                        let data = data else {
                            completion(.failure(error: ProductsServiceError.unexpectedResponse))
                            return
                    }
                    let productImage = ProductImage(managedObjectContext: strongSelf.managedObjectContext)
                    productImage.imageData = data
                    product.productImage = productImage
                    completion(.success(productImage: productImage))

                case .failure(let error):
                    completion(.failure(error: error))

                }

            })

        })

    }

}
