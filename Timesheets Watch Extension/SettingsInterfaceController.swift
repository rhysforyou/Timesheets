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
import RxSwift
import RxCocoa

final class SettingsViewModel {

    struct RowModel {
        let title: String
        let value: String
    }

    private enum MenuItem: Int, CaseIterable {
        case projectAssignment = 0
        case taskAssignment
        case workDays
    }

    var numberOfRows: Int {
        return MenuItem.allCases.count
    }

    func rowModel(at index: Int) -> RowModel? {
        guard let menuItem = MenuItem(rawValue: index) else { return nil }

        switch menuItem {
        case .projectAssignment:
            return RowModel(title: "Project", value: "---")
        case .taskAssignment:
            return RowModel(title: "Task", value: "---")
        case .workDays:
            return RowModel(title: "Days", value: "---")
        }
    }

    func presentationIntent(at index: Int) -> PresentationIntent? {
        guard let menuItem = MenuItem(rawValue: index) else { return nil }

        switch menuItem {
        case .projectAssignment:
            return PresentationIntent(controllerIdentifier: "ProjectAssignments", context: nil)
        case .taskAssignment:
            return PresentationIntent(controllerIdentifier: "TaskAssignments", context: nil)
        case .workDays:
            return PresentationIntent(controllerIdentifier: "WorkDays", context: nil)
        }
    }
}

class SettingsInterfaceController: WKInterfaceController {

    @IBOutlet var menuTable: WKInterfaceTable!

    private let viewModel = SettingsViewModel()

    private let timesheetsService = TimesheetsService()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        timesheetsService.refresh()
        
        menuTable.setNumberOfRows(viewModel.numberOfRows, withRowType: "MenuRow")

        for row in 0..<viewModel.numberOfRows {
            guard let rowModel = viewModel.rowModel(at: row) else { continue }
            let rowController = menuTable.rowController(at: row) as! MenuRowController

            rowController.titleLabel.setText(rowModel.title)
            rowController.valueLabel.setText(rowModel.value)
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
        if let intent = viewModel.presentationIntent(at: rowIndex) {
            pushController(withIntent: intent)
        }
    }
}

class MenuRowController: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var valueLabel: WKInterfaceLabel!

}
