//
//  ProductCollectionViewCell.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView?
    @IBOutlet var favouritedImageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var priceLabel: UILabel?

    static var reuseIdentifier = "ProductCollectionViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
}
