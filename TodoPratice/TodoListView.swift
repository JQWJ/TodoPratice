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
                if viewModel.visibleTodos.isEmpty {
                    ContentUnavailableView {
                        Label("할 일이 없습니다", systemImage: "checkmark.circle")
                    } description: {
                        Text("할 일을 추가해보세요")
                    } actions: {
                        Button("추가하기") {
                            showNewSheet = true
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                showNewSheet = true
                            }
                            .sheet(isPresented: $showNewSheet) {
                                AddTodoView(viewModel: viewModel)
                            }
        //                    Button("reset") {
        //                        viewModel.resetTodos()
        //                    }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                }
                    
                } else {
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
                        .onDelete(perform: viewModel.delete)
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
        //                    Button("reset") {
        //                        viewModel.resetTodos()
        //                    }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                }
            }

        }
    }
}

