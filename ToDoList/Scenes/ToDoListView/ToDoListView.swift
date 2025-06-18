//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import SwiftUI

struct ToDoListView: View {
    @Bindable var store: StoreOf<ToDoListFeature>
    
    private var shouldShowToggleAllButton: Bool {
        let nonEmptyActive = store.activeToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let nonEmptyCompleted = store.completedToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        return (nonEmptyActive.count + nonEmptyCompleted.count) > 1
    }
    
    private var shouldMarkAllCompleted: Bool {
        let nonEmptyActive = store.activeToDos.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        return !nonEmptyActive.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FilterType.allCases) { filter in
                        Button(action: {
                            store.send(.filterChanged(filter))
                        }) {
                            Text("\(filter.rawValue) (\(count(for: filter)))")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    filterBackground(for: filter)
                                )
                                .foregroundColor(
                                    store.selectedFilter == filter ? .white : .black
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            if store.activeToDos.isEmpty && store.completedToDos.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No to-dos yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                List {
                    ForEach(filteredToDos) { toDo in
                        ToDoRowView(
                            toDo: toDo,
                            onCheckTapped: {
                                store.send(.checkButtonTapped(id: toDo.id))
                            },
                            onTitleChanged: { newTitle in
                                store.send(.titleChanged(id: toDo.id, newTitle: newTitle))
                            },
                            onRemoveTapped: {
                                store.send(.removeToDo(id: toDo.id))
                            },
                            shouldFocus: isLastAndEmpty(toDo)
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                store.send(.removeToDo(id: toDo.id))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                store.send(.checkButtonTapped(id: toDo.id))
                            } label: {
                                Label(toDo.isActive ? "Complete" : "Undo", systemImage: toDo.isActive ? "checkmark.circle" : "arrow.uturn.left.circle")
                            }
                            .tint(toDo.isActive ? .green : .orange)
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
            
            Spacer()
        }
        .navigationTitle("To Do")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if store.selectedFilter == .inProgress,
                   shouldShowToggleAllButton {
                    Button(shouldMarkAllCompleted ? "Complete All" : "Uncheck All") {
                        store.send(.toggleAllToDos)
                    }
                    .foregroundStyle(.black)
                }
                
                if store.selectedFilter != .completed {
                    Button("Add") {
                        store.send(.addButtonTapped)
                    }
                    .disabled(isLastToDoIncomplete)
                    .foregroundStyle(isLastToDoIncomplete ? Color.gray.opacity(0.5) : .black)
                }
            }
        }
    }
    
    private var filteredToDos: IdentifiedArrayOf<ToDoModel> {
        switch store.selectedFilter {
        case .inProgress:
            return store.activeToDos
        case .completed:
            return store.completedToDos
        }
    }
    
    private func count(for filter: FilterType) -> Int {
        switch filter {
        case .inProgress:
            return store.activeToDos.count
        case .completed:
            return store.completedToDos.count
        }
    }
    
    private func isLastAndEmpty(_ toDo: ToDoModel) -> Bool {
        return toDo == store.activeToDos.last && toDo.title.isEmpty
    }
    
    private var isLastToDoIncomplete: Bool {
        guard let last = store.activeToDos.last else { return false }
        return last.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !last.isFinalized
    }
    
    private func filterBackground(for filter: FilterType) -> some View {
        let isSelected = store.selectedFilter == filter
        let color: Color
        switch filter {
        case .inProgress:
            color = isSelected ? .orange : .orange.opacity(0.2)
        case .completed:
            color = isSelected ? .green : .green.opacity(0.2)
        }
        return color.cornerRadius(20)
    }
}

#Preview {
    NavigationStack {
        ToDoListView(
            store: Store(
                initialState: ToDoListFeature.State(
                    activeToDos: []
                )
            ) {
                ToDoListFeature()._printChanges()
            }
        )
    }
}
