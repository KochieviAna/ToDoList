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
    @Dependency(\.toDoPersistence) var toDoPersistence
    
    @ObservableState
    struct State: Equatable {
        var activeToDos: IdentifiedArrayOf<ToDoModel> = []
        var completedToDos: IdentifiedArrayOf<ToDoModel> = []
        var selectedFilter: FilterType = .inProgress
    }
    
    enum Action: BindableAction, ViewAction {
        case binding(BindingAction<State>)
        case view(View)
        
        enum View {
            case addButtonTapped
            case checkButtonTapped(id: ToDoModel.ID)
            case filterChanged(FilterType)
            case titleChanged(id: ToDoModel.ID, newTitle: String)
            case toggleAllToDos
            case removeToDo(id: ToDoModel.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case let .view(viewAction):
                switch viewAction {
                case .addButtonTapped:
                    if let last = state.activeToDos.last,
                       last.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !last.isFinalized {
                        return .none
                    }
                    let newToDo = ToDoModel(id: UUID(), title: "", isActive: true, isFinalized: false)
                    state.activeToDos.append(newToDo)
                    toDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
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
                    toDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                    return .none
                    
                case let .filterChanged(newFilter):
                    state.selectedFilter = newFilter
                    return .none
                    
                case let .removeToDo(id):
                    state.activeToDos.remove(id: id)
                    state.completedToDos.remove(id: id)
                    toDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                    return .none
                    
                case let .titleChanged(id, newTitle):
                    if let index = state.activeToDos.firstIndex(where: { $0.id == id }) {
                        state.activeToDos[index].title = newTitle
                        if !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            state.activeToDos[index].isFinalized = true
                        }
                    }
                    toDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                    return .none
                    
                case .toggleAllToDos:
                    let nonEmptyActive = state.activeToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    guard !nonEmptyActive.isEmpty else { return .none }
                    
                    let moved = nonEmptyActive.map { var todo = $0; todo.isActive = false; return todo }
                    state.completedToDos.append(contentsOf: moved)
                    state.activeToDos.removeAll(where: { nonEmptyActive.map(\.id).contains($0.id) })
                    toDoPersistence.save(active: Array(state.activeToDos), completed: Array(state.completedToDos))
                    return .none
                }
                
            case .binding:
                return .none
            }
        }
    }
}
