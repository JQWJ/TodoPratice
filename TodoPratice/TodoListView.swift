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
                
                ForEach(viewModel.visibleTodos) { todo in

                            if !todo.isDone {
                                TodoRowView(todo: todo) {
                                    withAnimation(.easeOut) {
                                        viewModel.toggledone(todo)
                                    }
                                }
                            } else {

                                if viewModel.isCompletedExpanded {
                                    TodoRowView(todo: todo) {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                            viewModel.toggledone(todo)
                                        }
                                    }
                                }
                            }
                        }
                    .onMove { from, to in
                        viewModel.moveActive(from: from, to: to)
                    }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.visibleTodos)
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
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
}

