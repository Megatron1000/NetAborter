//
//  AppDelegate.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

    /// We hold onto a single user in order to save the favourite items
    lazy var user: User = {

        if let user = (try? self.managedObjectContext.fetchSingleEntity(User.self)) ?? nil {
            return user
        } else {
            return User(managedObjectContext: self.managedObjectContext)
        }

    } ()

    lazy fileprivate var managedObjectContext: NSManagedObjectContext = {
        do {
            let managedObjectContext = try NSManagedObjectContext(storeType: .sqLite)
            return managedObjectContext
        } catch {
            fatalError("Unable to create core data stack \(error)")
        }
    }()

}

// MARK: UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard
            let productsCollectionViewController = window?.rootViewController?.children.first as? ProductsCollectionViewController else {
                fatalError("Wrong initial view controller")
        }

        productsCollectionViewController.user = user

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        try? managedObjectContext.save()
    }

}
