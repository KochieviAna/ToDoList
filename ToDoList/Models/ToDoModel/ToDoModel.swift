//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import Foundation

@ObservableState
public struct ToDoModel: Equatable, Identifiable, Codable {
    public let id: UUID
    public var title = ""
    public var isActive = true
    public var isFinalized = false
    
    public init(id: UUID, title: String, isActive: Bool, isFinalized: Bool) {
        self.id = id
        self.title = title
        self.isActive = isActive
        self.isFinalized = isFinalized
    }
}

enum FilterType: String, CaseIterable, Equatable, Identifiable {
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { rawValue }
}
