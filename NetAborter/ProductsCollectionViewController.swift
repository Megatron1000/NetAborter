//
//  ProductsCollectionViewController.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import UIKit
import CoreData

class ProductsCollectionViewController: UICollectionViewController {

    // MARK: Collection View Layout Dimension Calculations

    struct LayoutDimensions {
        static let gap: CGFloat = 15
        static let itemsPerLine: CGFloat = 2
        static let cellAspectRatio: CGFloat = 1.8

        static var totalWhiteSpacePerLine: CGFloat {
            return (gap * 2) + ((itemsPerLine - 1) * gap)
        }

        static func cellSize(for collectionView: UICollectionView) -> CGSize {
            let cellWidth = floor((collectionView.frame.size.width - totalWhiteSpacePerLine) / itemsPerLine)
            return CGSize(width: cellWidth, height: cellWidth * cellAspectRatio)
        }

        static let edgeInsets = UIEdgeInsets(top: gap, left: gap, bottom: gap, right: gap)
    }

    // MARK: Properties

    var user: User?

    private lazy var refreshControl: UIRefreshControl = {
        let newRefreshControl = UIRefreshControl()
        newRefreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return newRefreshControl
    }()

    lazy var dataSource: ProductsDataSource = {
        guard let user = self.user else {
            fatalError("No user to create data source with")
        }
        return ProductsDataSource(user: user)
    }()

    // MARK: LifeCycle 

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.addSubview(refreshControl)
        collectionView?.dataSource = dataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshData(self)
    }

    // MARK: Refreshing Data

    @objc func refreshData(_ sender: AnyObject?) {

        refreshControl.beginRefreshing()

        dataSource.reloadData { [weak self] result in

            self?.refreshControl.endRefreshing()

            switch result {

            case .success:
                // Decided, for the sake of simplicity, to just call a full on reloadData, rather than implement perform batch updates with the fetch results controller 
                self?.collectionView?.reloadData()

            case .failure(let error):
                let alertController = UIAlertController(title: "Failed To Retrieve Products", message: error.localizedDescription, defaultActionTitle: "OK")
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: UICollectionViewDelegate methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.toggleIsFavourited(at: indexPath)
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: Collection View Flow Layout Delegate

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return LayoutDimensions.cellSize(for: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return LayoutDimensions.edgeInsets
    }

}
