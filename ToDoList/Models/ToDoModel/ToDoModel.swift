//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import Foundation

@ObservableState
struct ToDoModel: Equatable, Identifiable, Codable {
    let id: UUID
    var title = ""
    var isActive = true
    var isFinalized = false
}

enum FilterType: String, CaseIterable, Equatable, Identifiable {
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { rawValue }
}
