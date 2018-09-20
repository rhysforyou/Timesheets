//
//  LogTimesheetEntryIntentHandler.swift
//  TimesheetPalIntents
//
//  Created by Rhys Powell on 21/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import HarvestKit
import RxSwift

class LogTimesheetEntryIntentHandler: NSObject, LogTimesheetEntryIntentHandling {
    private let disposeBag = DisposeBag()

    func handle(intent: LogTimesheetEntryIntent, completion: @escaping (LogTimesheetEntryIntentResponse) -> Void) {
        guard let projectAssignmentID = intent.projectAssignmentID?.intValue,
            let taskAssignmentID = intent.taskAssignmentID?.intValue,
            let days = intent.days?.compactMap(WorkDay.init)
        else {
            completion(LogTimesheetEntryIntentResponse(code: .failure, userActivity: nil))
            return
        }

        let timesheetService = TimesheetsService()
        timesheetService
            .submitTimesheetEntries(projectID: projectAssignmentID, taskID: taskAssignmentID, days: days)
            .subscribe(onError: { _ in
                completion(LogTimesheetEntryIntentResponse(code: .failure, userActivity: nil))
            }, onCompleted: {
                completion(.success(taskName: "Test", projectName: "Test"))
            })
            .disposed(by: disposeBag)
    }
    
}
