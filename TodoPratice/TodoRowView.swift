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
        HStack(spacing: 8) {
                
            // 우선순위 컬러 바
            Rectangle()
                .fill(priorityColor)
                .frame(width: 4)
                .cornerRadius(2)
            
            Text(todo.title)
                .strikethrough(todo.isDone)
                .foregroundColor(todo.isDone ? .secondary : .primary)
            
            Spacer()
            
            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isDone ? .green : .gray)
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.vertical, 4)
    }
    
    private var priorityColor: Color {
        switch todo.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .clear
        }
    }
}
