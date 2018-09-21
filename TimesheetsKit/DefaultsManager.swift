//
//  DefaultsManager.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

public class DefaultsManager {
    public static let standard = DefaultsManager(.standard)

    public let userDefaults: UserDefaults

    public init (_ userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func registerDefaults() {
        userDefaults.register(defaults: [
            .lastSelectedProject: 0,
            .lastSelectedTask: 0
        ])
    }

    public var lastSelectedProject: Int {
        get {
            return userDefaults.integer(forKey: .lastSelectedProject)
        }
        set {
            userDefaults.set(newValue, forKey: .lastSelectedProject)
        }
    }

    public var lastSelectedTask: Int {
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
