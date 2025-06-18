//
//  ToDoRowView.swift
//  ToDoList
//
//  Created by Techzy on 17.06.25.
//

import SwiftUI
import ComposableArchitecture

struct ToDoRowView: View {
    let toDo: ToDoModel
    let onCheckTapped: () -> Void
    let onTitleChanged: (String) -> Void
    
    @State private var editableTitle: String
    
    init(
        toDo: ToDoModel,
        onCheckTapped: @escaping () -> Void,
        onTitleChanged: @escaping (String) -> Void
    ) {
        self.toDo = toDo
        self.onCheckTapped = onCheckTapped
        self.onTitleChanged = onTitleChanged
        _editableTitle = State(initialValue: toDo.title)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: $editableTitle)
                    .onChange(of: editableTitle) { _, newValue in
                        onTitleChanged(newValue)
                    }

                Spacer()

                Button(action: onCheckTapped) {
                    Image(systemName: toDo.isActive ? "circle" : "checkmark.circle.fill")
                        .foregroundStyle(.black)
                }
                .disabled(editableTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    ToDoRowView(toDo: ToDoModel(id: UUID()), onCheckTapped: {}, onTitleChanged: {_ in })
}
