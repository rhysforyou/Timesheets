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
import SVProgressHUD
import HarvestKit
import Intents
import IntentsUI

protocol TimesheetSettingsViewControllerDelegate: class {
    func projectRowSelected(projects: Observable<[ProjectAssignment]>, selectedProject: BehaviorRelay<ProjectAssignment?>)
    func taskRowSelected(tasks: Observable<[TaskAssignment]>, selectedTask: BehaviorRelay<TaskAssignment?>)
    func daysRowSelected(selectedDays: BehaviorRelay<[WorkDay]>)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.refresh()
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
        viewModel.submit().subscribe(onNext: { progress in
            SVProgressHUD.showProgress(progress, status: "Submitting Timesheet")
        }, onError: { [unowned self] error in
            SVProgressHUD.showError(withStatus: "Error With Submission")
            self.modalAlert(title: "Error Submitting Timesheet", message: error.localizedDescription)
        }, onCompleted: {
            SVProgressHUD.showSuccess(withStatus: "Timesheets Submitted")
        }, onDisposed: {
            SVProgressHUD.dismiss()
        }).disposed(by: disposeBag)
    }

    @IBAction func donateSiriShortcut(_ sender: Any) {
        let intent = LogTimesheetEntryIntent()

        intent.projectAssignmentID = viewModel.selectedProject.value?.id as NSNumber?
        intent.taskAssignmentID = viewModel.selectedTask.value?.id as NSNumber?
        intent.days = viewModel.selectedDays.value.map { $0.rawValue }
        intent.suggestedInvocationPhrase = "Log my timesheets"

        if let shortcut = INShortcut(intent: intent) {
            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }

    }
}

extension TimesheetSettingsViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }

}
