//
//  ProjectsViewModel.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectsViewModel {
    let projects: Observable<[ProjectAssignment]>
    let selectedProject: Variable<ProjectAssignment?>

    init(projects: Observable<[ProjectAssignment]>, selectedProject: Variable<ProjectAssignment?>) {
        self.projects = projects
        self.selectedProject = selectedProject
    }
}
