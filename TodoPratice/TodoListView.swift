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
                Picker("Filter", selection: $viewModel.filter) {
                    ForEach(TodoFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue)
                            .tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if !viewModel.activeTodos.isEmpty {
                    Section("미완료") {
                        ForEach(viewModel.activeTodos) { todo in
                            TodoRowView(todo: todo) {
                                viewModel.toggledone(todo)
                            }
                        }
                    }
                }
                
                if !viewModel.completedTodos.isEmpty {
                    Section {
                        if viewModel.isCompletedExpanded {
                            ForEach(viewModel.completedTodos) { todo in
                                TodoRowView(todo: todo) {
                                    viewModel.toggledone(todo)
                                }
                            }
                        }
                    } header: {
                        Button {
                            withAnimation(.easeInOut) {
                                viewModel.isCompletedExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                Text("완료 \(viewModel.completedTodos.count)")
                                Spacer()
                                Image(systemName: viewModel.isCompletedExpanded ? "chevron.down" : "chevron.right")
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.todos)
            .listStyle(.plain)
            .navigationTitle("Todo")
            .searchable(text: $viewModel.searchText, prompt: "할 일 검색")
            
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
