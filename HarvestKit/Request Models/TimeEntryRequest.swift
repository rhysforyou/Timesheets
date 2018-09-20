//
//  TimeEntryRequest.swift
//  HarvestKit
//
//  Created by Rhys Powell on 20/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

public struct TimeEntryRequest: Codable {
    let projectId: Int
    let taskId: Int
    let spentDate: Date
    let hours: Float
}
