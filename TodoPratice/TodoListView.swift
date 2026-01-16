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
    @State private var searchText = ""
    
    var filteredTodos: [TodoItem] {
        if searchText.isEmpty {
            return viewModel.todos
        } else {
            return viewModel.todos.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
//        VStack {
//            Picker("Filter", selection: $viewModel.filter) {
//                ForEach(TodoFilter.allCases) { filter in
//                    Text(filter.rawValue)
//                        .tag(filter)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding()
//        }
        // 네비게이션 바깥에 생성하기
        
        NavigationStack {
            List {
                ForEach(filteredTodos) { todo in
                    TodoRowView(
                        todo: todo,
                            onToggle: {
                        viewModel.toggledone(todo)
                            }
                    )
                }
                .onDelete { viewModel.delete(at: $0) }
                
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Filter", selection: $viewModel.filter) {
                        ForEach(TodoFilter.allCases) { filter in
                            Text(filter.rawValue)
                                .tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                }
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
        .navigationTitle("Todo")
        .searchable(text: $searchText, prompt: "할 일 검색")
    }
}
