//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                let saved = ToDoPersistence.load()
                ToDoListView(
                    store: Store(
                        initialState: ToDoListFeature.State(
                            activeToDos: IdentifiedArray(uniqueElements: saved.active),
                            completedToDos: IdentifiedArray(uniqueElements: saved.completed)
                        )
                    ) {
                        ToDoListFeature()
                    }
                )
            }
        }
    }
}
