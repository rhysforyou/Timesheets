//
//  ProjectAssignmentResponse.swift
//  HarvestKit
//
//  Created by Rhys Powell on 20/9/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation

public struct ProjectAssignmentResponse: Codable {
    let projectAssignments: [ProjectAssignment]
    let perPage: Int
    let totalPages: Int
    let totalEntries: Int
    let nextPage: Int?
    let previousPage: Int?
    let page: Int
    let links: [String: URL?]
}
