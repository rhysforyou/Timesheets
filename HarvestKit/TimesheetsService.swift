//
//  TimesheetsService.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

public class TimesheetsService {
    private let refreshSubject = PublishSubject<Void>()
    private let provider: MoyaProvider<Harvest>

    public let projectAssignments: Observable<[ProjectAssignment]>

    public init(provider: MoyaProvider<Harvest> = MoyaProvider<Harvest>()) {
        self.provider = provider

        projectAssignments = refreshSubject.asObservable()
            .flatMapLatest { _ in provider.rx.request(.currentUserProjectAssignments, callbackQueue: .main) }
            .filter(statusCodes: 200...299)
            .map(ProjectAssignmentResponse.self, using: Harvest.jsonDecoder)
            .map { $0.projectAssignments }
            .share(replay: 1, scope: .forever)
    }

    public func refresh() {
        refreshSubject.onNext(())
    }
    public func submitTimesheetEntries(project: ProjectAssignment, task: TaskAssignment, days: [WorkDay]) -> Observable<Float> {
        return submitTimesheetEntries(projectID: project.project.id, taskID: task.task.id, days: days)
    }

    public func submitTimesheetEntries(projectID: Int, taskID: Int, days: [WorkDay]) -> Observable<Float> {
        return Observable.create { [unowned self] observer in
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
                case .monday:
                    day = daysOfWeek[1]
                case .tuesday:
                    day = daysOfWeek[2]
                case .wednesday:
                    day = daysOfWeek[3]
                case .thursday:
                    day = daysOfWeek[4]
                case .friday:
                    day = daysOfWeek[5]
                }
                return Harvest.submitTimeEntry(projectID: projectID, taskID: taskID, date: day)
            }

            let progressIncrement = (1.0 / Float(targets.count))

            observer.onNext(0)

            return Observable.from(targets)
                .flatMap { [unowned self] in self.provider.rx.request($0).asObservable() }
                .enumerated()
                .subscribe(onNext: { (index, element) in
                    let progress = Float(index + 1) * progressIncrement
                    observer.onNext(progress)
                }, onError: { error in
                    observer.onError(error)
                }, onCompleted: {
                    observer.onCompleted()
                })
        }
    }
}
