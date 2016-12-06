//
//  Product+Additions.swift
//  NetAborter
//
//  Created by Mark Bridges on 26/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Product)
public class Product: NSManagedObject, DictionaryDeserializableManagedObject {

    // MARK: DictionaryDeserializableManagedObject Conformance

    public required convenience init?(context moc: NSManagedObjectContext, dictionary: [String:Any]) {

        guard
            let id = dictionary["id"],
            let name = dictionary["name"] as? String,
            let price = dictionary["price"] as? [String:Any] else {
                return nil
        }

        // Check we don't already have a product with this id
        let predicate = NSPredicate(format: "id LIKE %@", String(describing: id))
        let existingProductWithID: Product? = (try? moc.fetchSingleEntity(Product.self, predicate: predicate)) ?? nil
        guard existingProductWithID?.id == nil else { return nil }

        self.init(managedObjectContext: moc)

        // Converting id into a string, as it's used as an identifier and therefore shouldn't be thought of as a number that can be manipulated or represented in different ways
        self.id = String(describing: id)
        self.name = name
        self.price = Price(context: moc, dictionary: price)
    }

    // MARK: Getters

    var localizedPriceString: String? {
        return price?.localizedString
    }

    var image: UIImage? {
        return productImage?.image
    }

}
