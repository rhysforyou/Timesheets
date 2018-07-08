//
//  DefaultsManager.swift
//  TimesheetPal
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let standard = DefaultsManager(.standard)

    let userDefaults: UserDefaults

    init (_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func registerDefaults() {
        userDefaults.register(defaults: [
            .lastSelectedProject: 0,
            .lastSelectedTask: 0
        ])
    }

    var lastSelectedProject: Int {
        get {
            return userDefaults.integer(forKey: .lastSelectedProject)
        }
        set {
            userDefaults.set(newValue, forKey: .lastSelectedProject)
        }
    }

    var lastSelectedTask: Int {
        get {
            return userDefaults.integer(forKey: .lastSelectedTask)
        }
        set {
            userDefaults.set(newValue, forKey: .lastSelectedTask)
        }
    }
}

fileprivate extension String {
    static let lastSelectedProject = "LastSelectedProject"
    static let lastSelectedTask = "LastSelectedTask"
}
