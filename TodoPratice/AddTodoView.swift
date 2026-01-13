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
    
    let viewModel: TodoListViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("할 일 입력", text: $text)
            
            Button("추가") {
                viewModel.add(title: text)
                dismiss()
            }
        }
        .padding()
    }
}

