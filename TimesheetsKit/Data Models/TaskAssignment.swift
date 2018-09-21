//
//  TaskAssignment.swift
//  TimesheetsKit
//
//  Created by Rhys Powell on 20/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

public struct TaskAssignment: Codable {
    public let id: Int
    public let billable: Bool
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date
    public let task: Task
}
