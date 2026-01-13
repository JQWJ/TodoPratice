//
//  TodoRowView.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

struct TodoRowView: View {
    
    @Binding var todo: TodoItem
    
    var body: some View {
        HStack {
            Button {
                todo.isDone.toggle()
            } label: {
                Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
            }
            Text(todo.title)
                .strikethrough(todo.isDone)
        }
    }
}
