//
//  AddTodoView.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

struct AddTodoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var priority: TodoPriority = .low
    
    let viewModel: TodoListViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("할 일 입력", text: $text)
            Picker("우선순위", selection: $priority) {
                ForEach(TodoPriority.allCases, id: \.self) { p in
                    Text(p.title)
                }
            }
            .pickerStyle(.segmented)
            
            Button("추가") {
                viewModel.add(title: text, priority: priority)
                dismiss()
            }
        }
        .padding()
    }
}

