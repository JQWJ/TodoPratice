//
//  TodoRowView.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

struct TodoRowView: View {
    
    let todo: TodoItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
                Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                .scaleEffect(todo.isDone ? 1.1 : 1.0)
                .animation(.spring(), value: todo.isDone)
                    .foregroundColor(todo.isDone ? .green : .gray)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            onToggle()
                        }
                    }
        
            Text(todo.title)
                .strikethrough(todo.isDone)
                .foregroundColor(todo.isDone ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
