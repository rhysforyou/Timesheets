//
//  ProjectAssignment.swift
//  TimesheetsKit
//
//  Created by Rhys Powell on 20/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

public struct ProjectAssignment: Codable {
    public let id: Int
    public let isProjectManager: Bool
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let project: Project
    public let client: Client
    public let taskAssignments: [TaskAssignment]
}
