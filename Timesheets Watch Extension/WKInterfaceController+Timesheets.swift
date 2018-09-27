//
//  WKInterfaceController+Timesheets.swift
//  Timesheets Watch Extension
//
//  Created by Rhys Powell on 27/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import WatchKit

struct PresentationIntent {
    let controllerIdentifier: String
    let context: Any?
}

extension WKInterfaceController {
    func pushController(withIntent intent: PresentationIntent) {
        pushController(withName: intent.controllerIdentifier, context: intent.context)
    }
}

