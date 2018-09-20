//
//  ProjectsViewController.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProjectsViewControllerDelegate: class {
    func didSelectProject()
}

class ProjectsViewController: UITableViewController {
    var viewModel: ProjectsViewModel! = nil
    weak var delegate: ProjectsViewControllerDelegate? = nil

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.projects
            .bind(to: self.tableView.rx.items(cellIdentifier: "ProjectCell")) { row, element, cell in
                cell.textLabel?.text = element.project.name
                cell.detailTextLabel?.text = element.client.name
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(ProjectAssignment.self)
            .subscribe(onNext: { [unowned self] project in
                self.viewModel.selectedProject.accept(project)
                self.delegate?.didSelectProject()
            })
            .disposed(by: disposeBag)
    }
}
