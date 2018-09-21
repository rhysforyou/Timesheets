//
//  TasksViewController.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HarvestKit

protocol TasksViewControllerDelegate: class {
    func didSelectTask()
}

class TasksViewController: UITableViewController {
    var viewModel: TasksViewModel! = nil
    weak var delegate: TasksViewControllerDelegate? = nil

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.tasks
            .bind(to: self.tableView.rx.items(cellIdentifier: "TaskCell")) { row, element, cell in
                cell.textLabel?.text = element.task.name
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(TaskAssignment.self)
            .subscribe(onNext: { [unowned self] task in
                self.viewModel.selectedTask.accept(task)
                self.delegate?.didSelectTask()
            })
            .disposed(by: disposeBag)
    }
}
