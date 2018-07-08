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

class TimesheetSettingsViewModel {
    let provider: MoyaProvider<Harvest>
    let projects: Observable<[ProjectAssignment]>
    let tasks: Observable<[TaskAssignment]>
    let selectedProject: Variable<ProjectAssignment?>
    let selectedTask: Variable<TaskAssignment?>
    let selectedDays: Variable<[WorkDay]>

    private let disposeBag = DisposeBag()
    private let selectedTaskInCurrentProject: Observable<TaskAssignment?>

    init(provider: MoyaProvider<Harvest> = MoyaProvider<Harvest>(), defaults: DefaultsManager = .standard) {
        self.provider = provider

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        projects = provider.rx.request(.currentUserProjectAssignments, callbackQueue: .main)
            .filter(statusCodes: 200...299)
            .map(ProjectAssignmentResponse.self, using: jsonDecoder)
            .map { $0.projectAssignments }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)

        selectedProject = Variable(nil)

        tasks = selectedProject.asObservable()
            .map { $0?.taskAssignments ?? [] }

        selectedTask = Variable(nil)
        selectedDays = Variable(WorkDay.allCases)

        selectedTaskInCurrentProject = Observable.combineLatest(selectedProject.asObservable(), selectedTask.asObservable())
            .map { (project, task) -> TaskAssignment? in
                guard let project = project, let task = task, project.taskAssignments.contains(where: { $0.id == task.id }) else {
                    return nil
                }
                return task
        }

        // If the last seletcted project / task is in the API response, set our selected project / task accordingly
        projects.take(1).subscribe(onNext: { [unowned self] projects in
            if let project = projects.first(where: { $0.id == defaults.lastSelectedProject }) {
                self.selectedProject.value = project

                if let task = project.taskAssignments.first(where: { $0.id == defaults.lastSelectedTask }) {
                    self.selectedTask.value = task
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
}
