//
//  ProductServiceTests.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import XCTest
import CoreData
@testable import NetAborter

class ProductServiceTests: XCTestCase {

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

    func testRetrieveProductsCallsTheCorrectURL() {

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.success(data: nil)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        productService.retrieveProducts { _ in }

        XCTAssertEqual(httpClientMock.urlOfLastRequest, URL(string:"http://api.net-a-porter.com/NAP/GB/en/60/0/summaries?categoryIds=2"))
    }

    func testRetrieveProductsReturnsProducts() {

        let bundle = Bundle(for: ProductServiceTests.self)
        let jsonFixtureUrl = bundle.url(forResource: "products", withExtension: "json")!
        let data = try! Data(contentsOf: jsonFixtureUrl)

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.success(data: data)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        productService.retrieveProducts { result in

            switch result {
            case .success(let products):
                XCTAssertEqual(products.count, 60)

            default:
                XCTFail("Call with valid response failed")

            }
        }
    }

    func testRetrieveProductsReturnsAnErrorWithWhenTheCallFails() {

        let testError = ProductsService.ProductsServiceError.undeserializableResponse

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.failure(error: testError)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        productService.retrieveProducts { result in

            switch result {
            case .failure(let error):
                switch error {
                    case ProductsService.ProductsServiceError.undeserializableResponse:
                    XCTAssert(true)

                default:
                    XCTFail("Wrong error return")

                }

            default:
                XCTFail("Call with invalid response succeeded")

            }
        }

    }

    func testRetrieveImageForProductCallsTheCorrectURL() {

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.success(data: nil)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        product.id = "123"

        productService.retrieveImage(for: product, completion: { _ in })

        XCTAssertEqual(httpClientMock.urlOfLastRequest, URL(string:"http://cache.net-a-porter.com/images/products/123/123_fr_sl.jpg"))
    }

    func testRetrieveImageForProductReturnsAProductImage() {

        let bundle = Bundle(for: ProductServiceTests.self)
        let imageFixtureUrl = bundle.url(forResource: "productImage", withExtension: "jpg")!
        let data = try! Data(contentsOf: imageFixtureUrl)

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.success(data: data)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        let product = Product(managedObjectContext: managedObjectContext)
        product.id = "123"

        productService.retrieveImage(for: product, completion: { result in

            switch result {
            case .success(let productImage):
                XCTAssertNotNil(productImage.image)
                XCTAssertEqual(productImage.product, product)

            default:
                XCTFail("Call with valid response failed")

            }
        })
    }

    func testRetrieveImageForProductReturnsAnErrorWhenCallFails() {

        let testError = ProductsService.ProductsServiceError.undeserializableResponse

        let httpClientMock = HTTPClientMock()
        httpClientMock.mockedResult = HTTPClient.HTTPClientResult.failure(error: testError)

        let productService = ProductsService(httpClient: httpClientMock, managedObjectContext: managedObjectContext)

        let product = Product.newTestProductInContext(managedObjectContext: managedObjectContext)
        product.id = "123"

        productService.retrieveImage(for: product, completion: { result in

            switch result {
            case .failure(let error):
                switch error {
                case ProductsService.ProductsServiceError.undeserializableResponse:
                    XCTAssert(true)

                default:
                    XCTFail("Wrong error return")

                }

            default:
                XCTFail("Call with invalid response succeeded")

            }
        })

    }

    // MARK: HTTPClientMock

    class HTTPClientMock: HTTPClient {

        var urlOfLastRequest: URL?
        var mockedResult: HTTPClientResult?

        override func makeNetworkRequest(with url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {

            guard urlOfLastRequest == nil else {
                fatalError("HTTPClientMock called multiple times")
            }

            urlOfLastRequest = url

            guard let mockedResult = mockedResult else {
                fatalError("HTTPClientMock called with a mocked result to return")
            }

            completion(mockedResult)
        }
    }
}
