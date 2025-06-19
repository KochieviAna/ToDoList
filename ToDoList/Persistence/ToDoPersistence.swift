//
//  ToDoPersistence.swift
//  ToDoList
//
//  Created by Techzy on 18.06.25.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct ToDoPersistence: Sendable {
    public var save: @Sendable (_ active: [ToDoModel], _ completed: [ToDoModel]) -> Void = { _, _ in }
    public var load: @Sendable () -> (active: [ToDoModel], completed: [ToDoModel]) = { ([], []) }
}

extension ToDoPersistence: DependencyKey {
    public static var liveValue: ToDoPersistence {
        @Sendable func save(active: [ToDoModel], completed: [ToDoModel]) {
            let data = ToDoSaveData(active: active, completed: completed)
            if let encoded = try? JSONEncoder().encode(data) {
                UserDefaults.standard.set(encoded, forKey: ToDoSaveData.key)
            }
        }
        
        @Sendable func load() -> (active: [ToDoModel], completed: [ToDoModel]) {
            guard let data = UserDefaults.standard.data(forKey: ToDoSaveData.key),
                  let decoded = try? JSONDecoder().decode(ToDoSaveData.self, from: data)
            else {
                return ([], [])
            }
            return (decoded.active, decoded.completed)
        }
        
        return Self(
            save: save,
            load: load
        )
    }
}

public extension DependencyValues {
    var toDoPersistence: ToDoPersistence {
        get { self[ToDoPersistence.self] }
        set { self[ToDoPersistence.self] = newValue }
    }
}

private struct ToDoSaveData: Codable {
    static let key = "todos_data"
    var active: [ToDoModel]
    var completed: [ToDoModel]
}
