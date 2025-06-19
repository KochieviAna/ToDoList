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
    let onRemoveTapped: () -> Void
    let shouldFocus: Bool
    
    @State private var editableTitle: String
    @FocusState private var isFocused: Bool
    
    init(
        toDo: ToDoModel,
        onCheckTapped: @escaping () -> Void,
        onTitleChanged: @escaping (String) -> Void,
        onRemoveTapped: @escaping () -> Void,
        shouldFocus: Bool
    ) {
        self.toDo = toDo
        self.onCheckTapped = onCheckTapped
        self.onTitleChanged = onTitleChanged
        self.onRemoveTapped = onRemoveTapped
        self.shouldFocus = shouldFocus
        _editableTitle = State(initialValue: toDo.title)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Title", text: $editableTitle)
                    .focused($isFocused)
                    .onChange(of: editableTitle) { _, newValue in
                        onTitleChanged(newValue)
                    }
                    .submitLabel(.done)
                    .onSubmit {
                        editableTitle = editableTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        onTitleChanged(editableTitle)
                    }
                    .onChange(of: isFocused) { _, focused in
                        if !focused && editableTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onRemoveTapped()
                        }
                    }
                
                Spacer()
                
                Button(action: onCheckTapped) {
                    Image(systemName: toDo.isActive ? "circle" : "checkmark.circle.fill")
                        .foregroundStyle(.black)
                }
                .buttonStyle(.plain)
                .disabled(editableTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                if shouldFocus {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isFocused = true
                    }
                }
            }
        }
    }
}

#Preview {
    ToDoRowView(
        toDo: ToDoModel(
            id: UUID(),
            title: "Sample Todo",
            isActive: true,
            isFinalized: true
        ),
        onCheckTapped: {},
        onTitleChanged: { _ in },
        onRemoveTapped: {},
        shouldFocus: false
    )
}
