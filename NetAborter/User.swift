//
//  User.swift
//  NetAborter
//
//  Created by Mark Bridges on 27/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    func isProductFavourited(_ product: Product) -> Bool {

        guard let favouriteProducts = favouriteProducts else {
            return false
        }

        return favouriteProducts.contains(product)
    }

    func toggleIsProductFavourited(_ product: Product) {

        if isProductFavourited(product) {
            removeFromFavouriteProducts(product)
        } else {
            addToFavouriteProducts(product)
        }
    }


}
