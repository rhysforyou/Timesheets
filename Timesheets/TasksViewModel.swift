//
//  TasksViewModel.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import TimesheetsKit

class TasksViewModel {
    let tasks: Observable<[TaskAssignment]>
    let selectedTask: BehaviorRelay<TaskAssignment?>

    init(tasks: Observable<[TaskAssignment]>, selectedTask: BehaviorRelay<TaskAssignment?>) {
        self.tasks = tasks
        self.selectedTask = selectedTask
    }
}
