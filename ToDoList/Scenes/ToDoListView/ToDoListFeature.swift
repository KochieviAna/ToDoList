//
//  ToDoListFeature.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import SwiftUI

enum FilterType: String, CaseIterable, Equatable, Identifiable {
    case all = "All"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { rawValue }
}

@Reducer
struct ToDoListFeature {
    @ObservableState
    struct State: Equatable {
        var activeToDos: IdentifiedArrayOf<ToDoModel> = []
        var completedToDos: IdentifiedArrayOf<ToDoModel> = []
        var selectedFilter: FilterType = .all
    }
    
    enum Action: BindableAction {
        case addButtonTapped
        case binding(BindingAction<State>)
        case checkButtonTapped(id: ToDoModel.ID)
        case filterChanged(FilterType)
        case removeToDo(id: ToDoModel.ID)
        case titleChanged(id: ToDoModel.ID, newTitle: String)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let newToDo = ToDoModel(id: UUID(), title: "")
                state.activeToDos.append(newToDo)
                return .none
                
            case let .checkButtonTapped(id):
                if let index = state.activeToDos.firstIndex(where: { $0.id == id }) {
                    var toDo = state.activeToDos.remove(at: index)
                    toDo.isActive.toggle()
                    state.completedToDos.append(toDo)
                } else if let index = state.completedToDos.firstIndex(where: { $0.id == id }) {
                    var toDo = state.completedToDos.remove(at: index)
                    toDo.isActive.toggle()
                    state.activeToDos.append(toDo)
                }
                return .none
                
            case let .filterChanged(newFilter):
                state.selectedFilter = newFilter
                return .none
                
            case let .removeToDo(id):
                state.activeToDos.remove(id: id)
                state.completedToDos.remove(id: id)
                return .none
                
            case let .titleChanged(id, newTitle):
                if let index = state.activeToDos.firstIndex(where: { $0.id == id }) {
                    state.activeToDos[index].title = newTitle
                } else if let index = state.completedToDos.firstIndex(where: { $0.id == id }) {
                    state.completedToDos[index].title = newTitle
                }
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
