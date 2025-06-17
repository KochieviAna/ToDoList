//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import Foundation

@ObservableState
struct ToDoModel: Equatable, Identifiable {
    let id: UUID
    var title = ""
    var isActive = true
}
