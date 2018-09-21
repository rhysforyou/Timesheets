//
//  DaysViewController.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TimesheetsKit

class DaysViewModel {
    typealias Element = (day: WorkDay, selected: Bool)

    let selectedDays: BehaviorRelay<[WorkDay]>
    let rows: Observable<[Element]>

    init(selectedDays: BehaviorRelay<[WorkDay]>) {
        self.selectedDays = selectedDays
        self.rows = Observable.combineLatest(Observable.just(WorkDay.allCases), selectedDays.asObservable())
            .map { days, selectedDays -> [Element] in
                return days.map { day -> Element in (day: day, selected: selectedDays.contains(day)) }
            }
    }
}

class DaysViewController: UITableViewController {

    var viewModel: DaysViewModel! = nil

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.rows
            .bind(to: tableView.rx.items(cellIdentifier: "DayCell")) { row, element, cell in
                cell.textLabel?.text = element.day.rawValue
                cell.accessoryType = element.selected ? .checkmark : .none
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(DaysViewModel.Element.self)
            .subscribe(onNext: { [unowned self] element in
                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                let selectedDays = self.viewModel.selectedDays.value
                if selectedDays.contains(element.day) {
                    self.viewModel.selectedDays.accept(selectedDays.filter { $0 != element.day })
                } else {
                    self.viewModel.selectedDays.accept(selectedDays + [element.day])
                }
            })
            .disposed(by: disposeBag)
    }
}
