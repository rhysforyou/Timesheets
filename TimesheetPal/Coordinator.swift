//
//  Coordinator.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
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

    func projectRowSelected(projects: Observable<[ProjectAssignment]>, selectedProject: BehaviorRelay<ProjectAssignment?>) {
        let projectsVC = storyboard.instantiateProjectsViewController(with: projects, selectedProject: selectedProject)
        projectsVC.delegate = self
        navigationController.pushViewController(projectsVC, animated: true)
    }

    func taskRowSelected(tasks: Observable<[TaskAssignment]>, selectedTask: BehaviorRelay<TaskAssignment?>) {
        let tasksVC = storyboard.instantiateTasksViewController(with: tasks, selectedTask: selectedTask)
        tasksVC.delegate = self
        navigationController.pushViewController(tasksVC, animated: true)
    }

    func daysRowSelected(selectedDays: BehaviorRelay<[WorkDay]>) {
        let daysVC = storyboard.instantiateDaysViewController(with: selectedDays)
        navigationController.pushViewController(daysVC, animated: true)
    }

    func didSelectProject() {
        self.navigationController.popViewController(animated: true)
    }

    func didSelectTask() {
        self.navigationController.popViewController(animated: true)
    }
}

extension UIStoryboard {
    func instantiateProjectsViewController(with projects: Observable<[ProjectAssignment]>, selectedProject: BehaviorRelay<ProjectAssignment?>) -> ProjectsViewController {
        let projectsVC = instantiateViewController(withIdentifier: "ProjectsViewController") as! ProjectsViewController
        projectsVC.viewModel = ProjectsViewModel(projects: projects, selectedProject: selectedProject)
        return projectsVC
    }

    func instantiateTasksViewController(with tasks: Observable<[TaskAssignment]>, selectedTask: BehaviorRelay<TaskAssignment?>) -> TasksViewController {
        let tasksVC = instantiateViewController(withIdentifier: "TasksViewController") as! TasksViewController
        tasksVC.viewModel = TasksViewModel(tasks: tasks, selectedTask: selectedTask)
        return tasksVC
    }

    func instantiateDaysViewController(with selectedDays: BehaviorRelay<[WorkDay]>) -> DaysViewController {
        let daysVC = instantiateViewController(withIdentifier: "DaysViewController") as! DaysViewController
        daysVC.viewModel = DaysViewModel(selectedDays: selectedDays)
        return daysVC
    }
}
