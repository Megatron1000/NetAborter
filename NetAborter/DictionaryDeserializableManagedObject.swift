//
//  DictionaryDeserializable.swift
//  NetAborter
//
//  Created by Mark Bridges on 25/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData

/// Declares that an object can be inserted into a managed object context and instantiated from a serialized dictionary
protocol DictionaryDeserializableManagedObject {

    init?(context moc: NSManagedObjectContext, dictionary: [String:Any])
}
