//
//  InterfaceController.swift
//  Timesheets Watch Extension
//
//  Created by Rhys Powell on 21/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import WatchKit
import Foundation
import TimesheetsKit

class SettingsInterfaceController: WKInterfaceController {

    private enum MenuItem: Int, CaseIterable {
        case projectAssignment = 0
        case taskAssignment
        case workDays

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

    private let timesheetsService = TimesheetsService()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        timesheetsService.refresh()
        
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

    private func presentProjectAsssignments() {
        pushController(withName: "ProjectAssignments", context: nil)
    }

    private func presentTaskAsssignments() {
        pushController(withName: "TaskAssignments", context: nil)
    }

    private func presentWorkDays() {
        pushController(withName: "WorkDays", context: nil)
    }

    // MARK: - Table

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let menuItem = MenuItem(rawValue: rowIndex) else {
            return
        }

        switch menuItem {
        case .projectAssignment:
            presentProjectAsssignments()
        case .taskAssignment:
            presentTaskAsssignments()
        case .workDays:
            presentWorkDays()
        }
    }
}

class MenuRowController: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var valueLabel: WKInterfaceLabel!

}
