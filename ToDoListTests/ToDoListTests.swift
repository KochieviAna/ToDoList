//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Techzy on 17.06.25.
//

import ComposableArchitecture
import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    let store = TestStore<ToDoListFeature.State, ToDoListFeature.Action>(initialState: ToDoListFeature.State()) {
        ToDoListFeature()
    }
    func testFilterChanged() async {
        
        
        await store.send(.view(.filterChanged(.completed))) {
            $0.selectedFilter = .completed
        }
    }
}
