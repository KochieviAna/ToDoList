//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import Dependencies
import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                let initialState: ToDoListFeature.State = {
                    withDependencies {_ in 
                    } operation: {
                        let saved = DependencyValues().toDoPersistence.load()
                        return ToDoListFeature.State(
                            activeToDos: IdentifiedArray(uniqueElements: saved.active),
                            completedToDos: IdentifiedArray(uniqueElements: saved.completed)
                        )
                    }
                }()
                
                ToDoListView(
                    store: Store(
                        initialState: initialState
                    ) {
                        ToDoListFeature()
                    }
                )
            }
        }
    }
}
