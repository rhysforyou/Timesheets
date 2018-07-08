//
//  ViewController.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TimesheetSettingsViewControllerDelegate: class {
    func projectRowSelected(projects: Observable<[ProjectAssignment]>, selectedProject: Variable<ProjectAssignment?>)
    func taskRowSelected(tasks: Observable<[TaskAssignment]>, selectedTask: Variable<TaskAssignment?>)
    func daysRowSelected(selectedDays: Variable<[WorkDay]>)
    func submittedTimesheet(project: ProjectAssignment, task: TaskAssignment, days: [WorkDay])
}

class TimesheetSettingsViewController: UITableViewController {

    private enum Row: Int {
        case project = 0
        case task = 1
        case days = 2
    }

    @IBOutlet var projectDetailLabel: UILabel!
    @IBOutlet var taskDetailLabel: UILabel!
    @IBOutlet var daysDetailLabel: UILabel!

    private let viewModel = TimesheetSettingsViewModel()
    private let disposeBag = DisposeBag()

    var delegate: TimesheetSettingsViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.selectedProjectTitle
            .drive(projectDetailLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.selectedTaskTitle
            .drive(taskDetailLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.selectedDaysTitle
            .drive(daysDetailLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.canSubmit
            .drive(navigationItem.rightBarButtonItem!.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row(rawValue: indexPath.row) {
        case .project?:
            delegate?.projectRowSelected(projects: viewModel.projects, selectedProject: viewModel.selectedProject)
        case .task?:
            delegate?.taskRowSelected(tasks: viewModel.tasks, selectedTask: viewModel.selectedTask)
        case .days?:
            delegate?.daysRowSelected(selectedDays: viewModel.selectedDays)
        default:
            break
        }
    }

    @IBAction func submit(_ sender: Any) {
        guard let project = viewModel.selectedProject.value, let task = viewModel.selectedTask.value else {
            fatalError("Shouldn't have been able to tap the save button")
        }

        let days = viewModel.selectedDays.value
        delegate?.submittedTimesheet(project: project, task: task, days: days)
    }
}

