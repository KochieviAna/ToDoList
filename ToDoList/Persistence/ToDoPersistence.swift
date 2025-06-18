//
//  ToDoPersistence.swift
//  ToDoList
//
//  Created by Techzy on 18.06.25.
//

import Foundation

enum ToDoPersistence {
    private static let key = "todos_data"
    
    static func save(active: [ToDoModel], completed: [ToDoModel]) {
        let data = ToDoSaveData(active: active, completed: completed)
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func load() -> (active: [ToDoModel], completed: [ToDoModel]) {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode(ToDoSaveData.self, from: data)
        else {
            return ([], [])
        }
        return (decoded.active, decoded.completed)
    }
    
    private struct ToDoSaveData: Codable {
        var active: [ToDoModel]
        var completed: [ToDoModel]
    }
}
