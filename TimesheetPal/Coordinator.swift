//
//  Coordinator.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import Moya
import RxMoya

class Coordinator: TimesheetSettingsViewControllerDelegate, ProjectsViewControllerDelegate, TasksViewControllerDelegate {

    let navigationController: UINavigationController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let provider = MoyaProvider<Harvest>()
    let disposeBag = DisposeBag()

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.loadViewIfNeeded()

        let settingsVC = navigationController.viewControllers.first as! TimesheetSettingsViewController
        settingsVC.delegate = self
    }

    func projectRowSelected(projects: Observable<[ProjectAssignment]>, selectedProject: Variable<ProjectAssignment?>) {
        let projectsVC = storyboard.instantiateProjectsViewController(with: projects, selectedProject: selectedProject)
        projectsVC.delegate = self
        navigationController.pushViewController(projectsVC, animated: true)
    }

    func taskRowSelected(tasks: Observable<[TaskAssignment]>, selectedTask: Variable<TaskAssignment?>) {
        let tasksVC = storyboard.instantiateTasksViewController(with: tasks, selectedTask: selectedTask)
        tasksVC.delegate = self
        navigationController.pushViewController(tasksVC, animated: true)
    }

    func daysRowSelected(selectedDays: Variable<[WorkDay]>) {
        let daysVC = storyboard.instantiateDaysViewController(with: selectedDays)
        navigationController.pushViewController(daysVC, animated: true)
    }

    func submittedTimesheet(project: ProjectAssignment, task: TaskAssignment, days: [WorkDay]) {
        let calendar = NSCalendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today) - calendar.firstWeekday
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let daysOfWeek = weekdays
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .map { $0.addingTimeInterval(32400) }

        let targets = days.map { workDay -> Harvest in
            let day: Date
            switch workDay {
            case .monday: day = daysOfWeek[1]
            case .tuesday: day = daysOfWeek[2]
            case .wednesday: day = daysOfWeek[3]
            case .thursday: day = daysOfWeek[4]
            case .friday: day = daysOfWeek[5]
            }
            return Harvest.submitTimeEntry(projectID: project.project.id, taskID: task.task.id, date: day)
        }

        let progressIncrement = (1.0 / Float(targets.count))

        SVProgressHUD.showProgress(0, status: "Submitting Timesheet")
        Observable.from(targets)
            .flatMap { [unowned self] in self.provider.rx.request($0).asObservable() }
            .enumerated()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (index, element) in
                let progress = Float(index + 1) * progressIncrement
                SVProgressHUD.showProgress(progress, status: "Submitting Timesheet")
            }, onError: { error in
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }, onCompleted: {
                SVProgressHUD.showSuccess(withStatus: "Timesheets Submitted")
            }, onDisposed: {
                SVProgressHUD.dismiss()
            })
            .disposed(by: self.disposeBag)
    }

    func didSelectProject() {
        self.navigationController.popViewController(animated: true)
    }

    func didSelectTask() {
        self.navigationController.popViewController(animated: true)
    }
}

extension UIStoryboard {
    func instantiateProjectsViewController(with projects: Observable<[ProjectAssignment]>, selectedProject: Variable<ProjectAssignment?>) -> ProjectsViewController {
        let projectsVC = instantiateViewController(withIdentifier: "ProjectsViewController") as! ProjectsViewController
        projectsVC.viewModel = ProjectsViewModel(projects: projects, selectedProject: selectedProject)
        return projectsVC
    }

    func instantiateTasksViewController(with tasks: Observable<[TaskAssignment]>, selectedTask: Variable<TaskAssignment?>) -> TasksViewController {
        let tasksVC = instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
        tasksVC.viewModel = TasksViewModel(tasks: tasks, selectedTask: selectedTask)
        return tasksVC
    }

    func instantiateDaysViewController(with selectedDays: Variable<[WorkDay]>) -> DaysViewController {
        let daysVC = instantiateViewController(withIdentifier: "DaysViewController") as! DaysViewController
        daysVC.viewModel = DaysViewModel(selectedDays: selectedDays)
        return daysVC
    }
}
