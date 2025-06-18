//
//  ToDoListFeature.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ToDoListFeature {
    @ObservableState
    struct State: Equatable {
        var activeToDos: IdentifiedArrayOf<ToDoModel> = []
        var completedToDos: IdentifiedArrayOf<ToDoModel> = []
        var selectedFilter: FilterType = .inProgress
    }
    
    enum Action: BindableAction {
        case addButtonTapped
        case binding(BindingAction<State>)
        case checkButtonTapped(id: ToDoModel.ID)
        case filterChanged(FilterType)
        case removeToDo(id: ToDoModel.ID)
        case titleChanged(id: ToDoModel.ID, newTitle: String)
        case toggleAllToDos
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                if let last = state.activeToDos.last,
                   last.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !last.isFinalized {
                    return .none
                }
                let newToDo = ToDoModel(id: UUID(), title: "", isActive: true, isFinalized: false)
                state.activeToDos.append(newToDo)
                ToDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
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
                ToDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                return .none
                
            case let .filterChanged(newFilter):
                state.selectedFilter = newFilter
                return .none
                
            case let .removeToDo(id):
                state.activeToDos.remove(id: id)
                state.completedToDos.remove(id: id)
                ToDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                return .none
                
            case let .titleChanged(id, newTitle):
                if let index = state.activeToDos.firstIndex(where: { $0.id == id }) {
                    state.activeToDos[index].title = newTitle
                    if !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        state.activeToDos[index].isFinalized = true
                    }
                }
                ToDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                return .none
                
            case .toggleAllToDos:
                let nonEmptyActive = state.activeToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                let nonEmptyCompleted = state.completedToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                
                let shouldMarkAllCompleted = !nonEmptyActive.isEmpty
                
                if shouldMarkAllCompleted {
                    let moved = nonEmptyActive.map { var todo = $0; todo.isActive = false; return todo }
                    state.completedToDos.append(contentsOf: moved)
                    state.activeToDos.removeAll(where: { nonEmptyActive.map(\.id).contains($0.id) })
                } else {
                    let moved = nonEmptyCompleted.map { var todo = $0; todo.isActive = true; return todo }
                    state.activeToDos.append(contentsOf: moved)
                    state.completedToDos.removeAll(where: { nonEmptyCompleted.map(\.id).contains($0.id) })
                }
                ToDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
