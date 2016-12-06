//
//  NSManagedObjectContext+Additions.swift
//  Geek Quiz
//
//  Created by Mark Bridges on 13/05/2016.
//  Copyright © 2016 Hackney Homes. All rights reserved.
//

import CoreData

// MARK: Errors

enum CoreDataError: Error {
    case noMatchingObjectForEntityName
    case unableToCreateCoreDataStack
}

// MARK: StoreTypes

enum PersistentStoreType {

    case sqLite, binary, inMemory

    var stringConstant: String {
        switch self {
        case .sqLite:
            return NSSQLiteStoreType

        case .binary:
            return NSBinaryStoreType

        case .inMemory:
            return NSInMemoryStoreType
        }
    }
}

// MARK: Extension

extension NSManagedObjectContext {

    func deleteAllEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) throws {
        try fetchAllEntities(type, predicate: predicate).forEach({ object in
            delete(object)
        })
    }

    func fetchAllEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) throws -> [T] {
        let fetchRequest: NSFetchRequest = try fetchRequestForEntities(type, predicate: predicate)

        return try fetch(fetchRequest)
    }

    func fetchSingleEntity<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) throws -> T? {
        let results: [T] = try fetchAllEntities(type, predicate: predicate)

        return results.last
    }

    fileprivate func fetchRequestForEntities<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate?) throws -> NSFetchRequest<T> {

        guard
            let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: T.entityName, in: self) else {
                throw CoreDataError.noMatchingObjectForEntityName
        }

        let fetchRequest = NSFetchRequest<T>()
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate

        return fetchRequest
    }

    // MARK: Convenience Init

    /// Creates a fully initialised core data stack
    convenience init(storeType: PersistentStoreType) throws {
        self.init(concurrencyType: .mainQueueConcurrencyType)

        let DBNameAndExtension = "db.sqlite"

        guard
            let mom = NSManagedObjectModel.mergedModel(from: nil),
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            else {
                throw CoreDataError.unableToCreateCoreDataStack
        }

        let documentsDirectoryURL = URL(fileURLWithPath: documentsDirectory, isDirectory: true)
        let storeURL = documentsDirectoryURL.appendingPathComponent(DBNameAndExtension)

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.persistentStoreCoordinator = psc

        try psc.addPersistentStore(ofType: storeType.stringConstant, configurationName: nil, at: storeURL)
    }

}
