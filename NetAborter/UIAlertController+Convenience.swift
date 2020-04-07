//
//  UIAlertController+ErrorHelpers.swift
//  NetAborter
//
//  Created by Mark Bridges on 24/11/2016.
//  Copyright © 2016 BridgeTech. All rights reserved.
//

import UIKit

extension UIAlertController {

    convenience init(title: String?, message: String?, defaultActionTitle: String?, dismissedHandler: (() -> Void)? = nil) {

        self.init(title: title, message: message, preferredStyle: .alert)

        addAction(UIAlertAction(title: defaultActionTitle, style: .default, handler: { action in
            dismissedHandler?()
        }))

    }

}
