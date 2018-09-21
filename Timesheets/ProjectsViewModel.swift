//
//  ProjectsViewModel.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import HarvestKit

class ProjectsViewModel {
    let projects: Observable<[ProjectAssignment]>
    let selectedProject: BehaviorRelay<ProjectAssignment?>

    init(projects: Observable<[ProjectAssignment]>, selectedProject: BehaviorRelay<ProjectAssignment?>) {
        self.projects = projects
        self.selectedProject = selectedProject
    }
}
