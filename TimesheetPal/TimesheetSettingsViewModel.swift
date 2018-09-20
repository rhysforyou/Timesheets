//
//  TimesheetSettingsViewModel.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxMoya
import Moya
import HarvestKit

class TimesheetSettingsViewModel {
    private let service: TimesheetsService
    private let disposeBag = DisposeBag()
    private let selectedTaskInCurrentProject: Observable<TaskAssignment?>

    let tasks: Observable<[TaskAssignment]>
    let selectedProject: BehaviorRelay<ProjectAssignment?>
    let selectedTask: BehaviorRelay<TaskAssignment?>
    let selectedDays: BehaviorRelay<[WorkDay]>

    init(service: TimesheetsService = TimesheetsService(), defaults: DefaultsManager = .standard) {
        self.service = service

        selectedProject = BehaviorRelay(value: nil)

        tasks = selectedProject.asObservable()
            .map { $0?.taskAssignments ?? [] }

        selectedTask = BehaviorRelay(value: nil)
        selectedDays = BehaviorRelay(value: WorkDay.allCases)

        selectedTaskInCurrentProject = Observable.combineLatest(selectedProject.asObservable(), selectedTask.asObservable())
            .map { (project, task) -> TaskAssignment? in
                guard let project = project, let task = task, project.taskAssignments.contains(where: { $0.id == task.id }) else {
                    return nil
                }
                return task
        }

        // If the last seletcted project / task is in the API response, set our selected project / task accordingly
        self.service.projectAssignments.take(1).subscribe(onNext: { [unowned self] projects in
            if let project = projects.first(where: { $0.id == defaults.lastSelectedProject }) {
                self.selectedProject.accept(project)

                if let task = project.taskAssignments.first(where: { $0.id == defaults.lastSelectedTask }) {
                    self.selectedTask.accept(task)
                }
            }
        }).disposed(by: disposeBag)

        // Update defaults when selection changes
        selectedProject.asObservable()
            .subscribe(onNext: { project in
                if let project = project {
                    defaults.lastSelectedProject = project.id
                }
            })
            .disposed(by: disposeBag)

        selectedTask.asObservable()
            .subscribe(onNext: { task in
                if let task = task {
                    defaults.lastSelectedTask = task.id
                }
            })
            .disposed(by: disposeBag)
    }

    var projects: Observable<[ProjectAssignment]> {
        return service.projectAssignments
    }

    var selectedProjectTitle: Driver<String> {
        return projects
            .flatMapLatest { [unowned self] _ in self.selectedProject.asObservable() }
            .map { $0?.project.name ?? "None" }
            .startWith("Loading…")
            .asDriver(onErrorJustReturn: "Error")
    }

    var selectedTaskTitle: Driver<String> {
        return projects
            .flatMapLatest { [unowned self] _ in self.selectedTaskInCurrentProject }
            .map { $0?.task.name ?? "None" }
            .startWith("Loading…")
            .asDriver(onErrorJustReturn: "Error")
    }

    var selectedDaysTitle: Driver<String> {
        return selectedDays.asObservable()
            .map { $0.map({ $0.abbreviation }).joined(separator: ", ") }
            .asDriver(onErrorJustReturn: "Error")
    }

    var canSubmit: Driver<Bool> {
        return Observable.combineLatest(selectedProject.asObservable(), selectedTaskInCurrentProject, selectedDays.asObservable())
            .map { project, task, days in
                project != nil && task != nil && !days.isEmpty
            }
            .asDriver(onErrorJustReturn: false)
    }

    func refresh() {
        service.refresh()
    }

    func submit() -> Observable<Float> {
        guard let project = selectedProject.value, let task = selectedTask.value else {
            fatalError("Shouldn't have been able to tap the save button")
        }

        let days = selectedDays.value

        return service.submitTimesheetEntries(project: project, task: task, days: days)
    }
}
