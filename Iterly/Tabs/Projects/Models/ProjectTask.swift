//
//  ProjectTask.swift
//  Iterly
//
//  Created by Filippo Cilia on 01/03/2026.
//

import Foundation
import SwiftData

@Model
final class ProjectTask: Identifiable {
    var id: UUID = UUID()
    var title: String = "Task"
    var details: String? = nil
    var status: TaskStatus = TaskStatus.default
    var dueDate: Date = Date.now.addingTimeInterval(14 * 24 * 60 * 60) // 2 weeks from now
    var priority: TaskPriority = TaskPriority.default
    var creationDate: Date = Date.now
    var project: Project

    init(
        id: UUID = UUID(),
        title: String = "Task",
        details: String? = nil,
        status: TaskStatus = TaskStatus.default,
        dueDate: Date = Date.now.addingTimeInterval(14 * 24 * 60 * 60), // 2 weeks from now
        priority: TaskPriority = TaskPriority.default,
        creationDate: Date = Date.now,
        project: Project
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.status = status
        self.dueDate = dueDate
        self.priority = priority
        self.creationDate = creationDate
        self.project = project
    }
}
