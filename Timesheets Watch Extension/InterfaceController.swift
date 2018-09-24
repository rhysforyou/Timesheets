//
//  InterfaceController.swift
//  Timesheets Watch Extension
//
//  Created by Rhys Powell on 21/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import WatchKit
import Foundation

class MenuRowController: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var valueLabel: WKInterfaceLabel!

}

class InterfaceController: WKInterfaceController {

    private enum MenuItem: CaseIterable {
        case projectAssignment, taskAssignment, workDays

        var title: String {
            switch self {
            case .projectAssignment:
                return "Project"
            case .taskAssignment:
                return "Task"
            case .workDays:
                return "Days"
            }
        }
    }

    @IBOutlet var menuTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        menuTable.setNumberOfRows(MenuItem.allCases.count, withRowType: "MenuRow")

        for (row, menuItem) in MenuItem.allCases.enumerated() {
            let rowController = menuTable.rowController(at: row) as! MenuRowController
            rowController.titleLabel.setText(menuItem.title)
            rowController.valueLabel.setText("---")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func logTimesheets() {
    }
}
