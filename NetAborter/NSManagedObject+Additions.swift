//
//  NSManagedObject+Additions.swift
//  Geek Quiz
//
//  Created by Mark Bridges on 14/05/2016.
//  Copyright © 2016 BridgeTech Solutions. All rights reserved.
//

import CoreData

extension NSManagedObject {

    class var entityName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }

    /// Required for backwards compatibility with iOS 9
    convenience init(managedObjectContext moc: NSManagedObjectContext) {
        if #available(iOS 10.0, macOS 10.12, *) {
            self.init(context: moc)
        } else {
            let name = String(describing: type(of: self))
            guard let entityDescription = NSEntityDescription.entity(forEntityName: name, in: moc) else {
                fatalError("Unable to create entity description with \(name)")
            }
            self.init(entity: entityDescription, insertInto: moc)
        }
    }

}
