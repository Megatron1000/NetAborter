//
//  Price+Additions.swift
//  NetAborter
//
//  Created by Mark Bridges on 26/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import Foundation
import CoreData

@objc(Price)
public class Price: NSManagedObject, DictionaryDeserializableManagedObject {

    // MARK: DictionaryDeserializableManagedObject Conformance

    public required convenience init?(context moc: NSManagedObjectContext, dictionary: [String:Any]) {

        guard
            let amount = dictionary["amount"] as? Int,
            let divisor = dictionary["divisor"] as? Int,
            let currency = dictionary["currency"] as? String else {
                return nil
        }

        self.init(managedObjectContext: moc)

        let decimalAmount = NSDecimalNumber(value: amount)
        let decimalDivisor = NSDecimalNumber(value: divisor)

        self.amount = decimalAmount.dividing(by: decimalDivisor)
        self.currency = currency
    }

    // MARK: Getters

    var localizedString: String? {

        guard
            let amount = amount,
            let currency = currency else { return nil }

        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.currencyCode = currency

        return formatter.string(from: amount)
    }

}
