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
    }
}
