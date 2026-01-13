//
//  ContentView.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showNewSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.todos) { $todo in
                    TodoRowView(todo: $todo)
                }
                .onDelete { viewModel.delete(at: $0) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showNewSheet = true
                    }
                    .sheet(isPresented: $showNewSheet) {
                        AddTodoView(viewModel: viewModel)
                    }
                }
            }
            
        }
    }
}
