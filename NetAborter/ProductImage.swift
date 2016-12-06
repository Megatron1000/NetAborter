//
//  Image+Additions.swift
//  NetAborter
//
//  Created by Mark Bridges on 26/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(ProductImage)
public class ProductImage: NSManagedObject {

    var image: UIImage? {

        guard let imageData = imageData as? Data else { return nil }

        return UIImage(data: imageData)
    }
}
